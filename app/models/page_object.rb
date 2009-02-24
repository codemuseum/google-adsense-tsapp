class PageObject < ActiveRecord::Base
  include ThriveSmartObjectMethods

  self.caching_default = :any_page_object_update 
  #[in :forever, :page_object_update, :any_page_object_update, 'data_update[datetimes]', :never, 'interval[5]']

  validates_associated :ad_unit
  before_save :save_ad_unit

  belongs_to :ad_unit
  
  def default_ad_unit
    @default_ad_unit ||= AdUnit.default_for_site(self.site_uid).first
  end
  
  def has_ad_unit?
    displayed_ad_unit
  end
  
  def displayed_ad_unit
    self.ad_unit || default_ad_unit
  end
  
  def all_ad_units
    @all_ad_units ||= AdUnit.all_units_for(self.site_uid).map { |au| [au.nickname, au.id] }
  end

  def assigned_ad_unit=(hash)
    edited_unit = hash.delete(:edited_unit)
    if hash[:id].blank?
      self.ad_unit = AdUnit.new_for_site(self.site_uid, hash)
      @ad_unit_updated = true
    else
      self.ad_unit = AdUnit.all_units_for(self.site_uid).find_by_id(hash[:id])
      if edited_unit == 'true' || edited_unit == '1'
        self.ad_unit.attributes = hash
        @ad_unit_updated = true
      end
    end
  end
  
  protected
    def save_ad_unit
      self.ad_unit.save if @ad_unit_updated
    end
  
end
