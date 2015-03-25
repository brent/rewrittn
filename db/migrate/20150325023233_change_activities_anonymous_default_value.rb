class ChangeActivitiesAnonymousDefaultValue < ActiveRecord::Migration
  def change
    change_column_default :activities, :anonymous, nil
  end
end
