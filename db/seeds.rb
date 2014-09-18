# encoding: UTF-8
# This file is auto-generated from the current content of the database. Instead
# of editing this file, please use the migrations feature of Seed Migration to
# incrementally modify your database, and then regenerate this seed file.
#
# If you need to create the database on another system, you should be using
# db:seed, not running all the migrations from scratch. The latter is a flawed
# and unsustainable approach (the more migrations you'll amass, the slower
# it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Base.transaction do

  UserRole.create({"role"=>"Admin"}, :without_protection => true)

  UserRole.create({"role"=>"Tester"}, :without_protection => true)
  ActiveRecord::Base.connection.reset_pk_sequence!('user_roles')
end

SeedMigration::Migrator.bootstrap(20140918142939)
