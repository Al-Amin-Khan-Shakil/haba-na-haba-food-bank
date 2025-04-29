class Request < ApplicationRecord
  belongs_to :branch
  belongs_to :district
  belongs_to :county
  belongs_to :sub_county
  belongs_to :user
end
