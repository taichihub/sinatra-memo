# frozen_string_literal: true

# Noteクラスは、メモアプリでのメモに対するデータベース操作を管理します
class Note
  def self.find(id)
    DB.with { |conn| conn.exec_params('SELECT * FROM notes WHERE id = $1', [id]).first }
  end

  def self.all
    DB.with { |conn| conn.exec('SELECT * FROM notes ORDER BY id') }
  end

  def self.create(title:, content:)
    sql = 'INSERT INTO notes (title, content) VALUES ($1, $2) RETURNING id'
    DB.with { |conn| conn.exec_params(sql, [title, content]).first['id'] }
  end

  def self.update(id, title:, content:)
    sql = 'UPDATE notes SET title = $1, content = $2 WHERE id = $3'
    DB.with { |conn| conn.exec_params(sql, [title, content, id]) }
  end

  def self.delete(id)
    sql = 'DELETE FROM notes WHERE id = $1'
    DB.with { |conn| conn.exec_params(sql, [id]) }
  end
end
