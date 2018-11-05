class AddApprovalToReferrals < ActiveRecord::Migration[5.2]
  def change
    add_reference :referrals, :approved_by, index: true, foreign_key: { to_table: :coordinators }
    add_column :referrals, :approved_at, :datetime
  end
end
