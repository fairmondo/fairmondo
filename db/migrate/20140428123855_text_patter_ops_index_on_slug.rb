class TextPatterOpsIndexOnSlug < ActiveRecord::Migration
  # https://github.com/norman/friendly_id/issues/369
  def up
    sql = ActiveRecord::Base.connection();
    if sql.is_a? ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
      sql.execute("CREATE INDEX text_pattern_index_on_slug ON articles (slug text_pattern_ops);")
    end
  end

  def down
  end
end
