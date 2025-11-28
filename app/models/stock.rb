class Stock < ApplicationRecord
  belongs_to :warehouse
  belongs_to :product
end
