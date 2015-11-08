module Province
  extend ActiveSupport::Concern

  def province
    Settings.provinces.detect { |p| p.abbr == province_id }
  end
end
