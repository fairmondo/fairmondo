# This module enables create/update/delete of Articles based on the action
# attribute. Currently used for mass uploads.
#
# == License:
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
module Article::DynamicProcessing
  extend ActiveSupport::Concern

  included do
    # Action attribute: c/create/u/update/d/delete - for export and csv upload
    attr_accessor :action

    # When an action is set, modify the save call to reflect what should be done
    # @return [Article] Article ready to save or containing an error
    def self.create_or_find_according_to_action attribute_hash, user
      case attribute_hash['action']
      when 'c', 'create'
        Article.new attribute_hash.merge({ action: :create })
      when 'u', 'update', 'x', 'delete', 'a', 'activate', 'd', 'deactivate'
        Article.process_dynamic_update attribute_hash, user
      when nil
        attribute_hash['action'] = Article.get_processing_default attribute_hash
        Article.create_or_find_according_to_action attribute_hash, user #recursion happens once
      when 'nothing'
        # Keep article as is. We could update it, but this conflicts with locked articles
        article = Article.find_by_id_or_custom_seller_identifier attribute_hash, user
        article.action = :nothing
      else
        Article.create_error_article I18n.t("mass_uploads.errors.unknown_action")
      end
    end

    # Perform Validations without clearing the base errors on this object.
    # Need this for setting things in create_error_article
    def was_invalid_before?
      unless self.errors[:base].any? # If there are base errors something went wrong in general and we can skip the other validations
        base_errors = self.errors.dup # save errors before .valid? call because it clears errors
        self.valid? # preform validation
        base_errors.each do |key,error| # readd old error msgs
          self.errors.add(key,error)
        end
      end
      self.errors.any?
    end

    private
      # We allow sellers to use their custom field as an identifier but we need the ID internally
      def self.find_by_id_or_custom_seller_identifier attribute_hash, user
        if attribute_hash['id']
          article = user.articles.where(id: attribute_hash['id']).first
        elsif attribute_hash['custom_seller_identifier']
          article = user.articles.
            where(custom_seller_identifier: attribute_hash['custom_seller_identifier']).
            limit(1).first
        else
          article = Article.create_error_article  I18n.t("mass_uploads.errors.no_identifier")
        end

        unless article
          article = Article.create_error_article  I18n.t("mass_uploads.errors.article_not_found")
        end

        article
      end

      # Process update or state change
      def self.process_dynamic_update attribute_hash, user
        article = Article.find_by_id_or_custom_seller_identifier attribute_hash, user

        case attribute_hash['action']
        when 'u', 'update'
          article = Article.edit_as_new article unless article.preview?
          article.attributes = attribute_hash
          article.action = :update
        when 'x', 'delete'
          article.action = :delete
        when 'a', 'activate'
          article.action = :activate
        when 'd', 'deactivate'
          article.action = :deactivate
        end
        article
      end

      # Defaults: create when no ID is set, does nothing when an ID exists
      # @return [String]
      def self.get_processing_default attribute_hash
        (attribute_hash['id'] || attribute_hash['custom_seller_identifier']) ? 'nothing' : 'create'
      end

      # Get article with error message for display in MassUpload#new error list
      # @param error_message [String] Message to display
      # @return [Article] Article containing error field
      def self.create_error_article error_message
        article = Article.new
        article.errors[:base] = error_message
        article
      end
  end

  # Replacement for save! method - Does different things based on the action attribute
  def process!
    if [:activate, :create, :update].include?(self.action)
      self.activation_action = self.action.to_s
    end
    case self.action
    when :delete
      self.state = "closed"
      self.activation_action = nil
    when :deactivate
      self.state = "locked"
      self.activation_action = nil
    end
    self.save!
  end

  def remove_activation_action
    self.activation_action = nil
    self.save
  end
end
