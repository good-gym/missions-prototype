class CreateReferralTransitions < ActiveRecord::Migration[5.2]
  def change
    create_table :referral_transitions do |t|
      t.string :to_state, null: false
      t.json :metadata, default: {}
      t.integer :sort_key, null: false
      t.integer :referral_id, null: false
      t.boolean :most_recent, null: false

      t.references :transitioner,
                   polymorphic: true,
                   index: { name: "index_referral_transitions_transitioner" }

      # If you decide not to include an updated timestamp column in your transition
      # table, you'll need to configure the `updated_timestamp_column` setting in your
      # migration class.
      t.timestamps null: false
    end

    # Foreign keys are optional, but highly recommended
    add_foreign_key :referral_transitions, :referrals

    add_index(:referral_transitions,
              [:referral_id, :sort_key],
              unique: true,
              name: "index_referral_transitions_parent_sort")
    add_index(:referral_transitions,
              [:referral_id, :most_recent],
              unique: true,
              where: 'most_recent',
              name: "index_referral_transitions_parent_most_recent")
  end
end
