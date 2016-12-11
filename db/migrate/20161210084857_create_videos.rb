class CreateVideos < ActiveRecord::Migration[5.0]
  def change
    create_table :videos do |t|
      t.string :yt_id, null: false
      t.string :title
      t.text :description
      t.text :snippet
      t.boolean :auto_transcribed, default: false
      t.boolean :transcribed, default: false
      t.text :auto_transcription
      t.text :transcription

      t.timestamps
    end

    add_index :videos, :yt_id, unique: true
    add_index :videos, :auto_transcribed
    add_index :videos, :transcribed
  end
end
