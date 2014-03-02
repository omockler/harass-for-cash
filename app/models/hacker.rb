module HarassForCash
  module Models
    class Hacker
      include MongoMapper::Document

      key :name,  String, required: true
      key :email, String, required: true, unique: true
      key :qr,    String, required: true
      timestamps!

      belongs_to :event
    end
  end
end