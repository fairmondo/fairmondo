class TextPatterOpsIndexOnSlug < ActiveRecord::Migration
  def up
    sql = ActiveRecord::Base.connection();
    if sql.is_a? ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
      sql.execute("CREATE INDEX text_pattern_index_on_slug ON articles (slug text_pattern_ops);")
    end
  end

  def down
  end
end
