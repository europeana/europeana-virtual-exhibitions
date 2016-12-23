class UpdateRightsStatements < ActiveRecord::Migration
  def up
    Alchemy::EssenceCredit.connection.execute("UPDATE alchemy_essence_credits SET license = 'RS_INC' WHERE license = 'RR_free' or license = 'RR_paid'")
    Alchemy::EssenceCredit.connection.execute("UPDATE alchemy_essence_credits SET license = 'RS_NOC_NC' WHERE license = 'RS_OOC'")
    Alchemy::EssenceCredit.connection.execute("UPDATE alchemy_essence_credits SET license = 'RS_INC_OW_EU' WHERE license = 'orphan'")
    Alchemy::EssenceCredit.connection.execute("UPDATE alchemy_essence_credits SET license = 'RS_CNE' WHERE license = 'unknown'")
  end

  def down
    # this migration is not revertable as multiple values are mapped to single values.
  end
end
