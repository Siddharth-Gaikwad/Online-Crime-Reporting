class Branch < ApplicationRecord
  has_many :case_reports, dependent: :destroy

  def self.nearest_branch(lat, lon)
    all.min_by do |branch|
      haversine(lat.to_f, lon.to_f, branch.latitude.to_f, branch.longitude.to_f)
    end
  end

  def self.haversine(lat1, lon1, lat2, lon2)
    rad = Math::PI / 180
    rkm = 6371
    dlat = (lat2 - lat1) * rad
    dlon = (lon2 - lon1) * rad
    lat1, lat2 = lat1 * rad, lat2 * rad

    a = Math.sin(dlat/2)**2 + Math.cos(lat1) * Math.cos(lat2) * Math.sin(dlon/2)**2
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
    rkm * c
  end

end
