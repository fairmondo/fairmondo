#
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
class ChangeCardinalityOfImages < ActiveRecord::Migration
  class Image < ActiveRecord::Base

    attr_accessible :image

    has_and_belongs_to_many :articles
  end

  class Article  < ActiveRecord::Base

  end

  def up
    create_table :articles_images, :id => false do |t|
        t.references :image
        t.references :article
    end
    add_index :articles_images, [:image_id, :article_id]
    add_index :articles_images, [:article_id, :image_id]
    Image.reset_column_information
    Image.all.each do |image|
      if image.article_id
        article = Article.find image.article_id
        image.articles << article
      end
    end
    remove_column :images, :article_id
  end

  def down
    add_column :images, :article_id, :integer
    Image.reset_column_information
    Images.all.each do |image|
      image.article_id = image.articles.first.id
    end
    drop_table :articles_images
  end
end
