# frozen_string_literal: true
class AddLogoToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :logo, :string
  end
end
