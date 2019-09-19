# This migration comes from acts_as_taggable_on_engine (originally 1)
class ActsAsTaggableOnMigration < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :name
      t.string :tag_type
    end

    create_table :taggings do |t|
      t.references :tag

      # You should make sure that the column created is
      # long enough to store the required class names.
      t.references :taggable, polymorphic: true
      t.references :tagger, polymorphic: true

      # Limit is created to prevent MySQL error on index
      # length for MyISAM table type: http://bit.ly/vgW2Ql
      t.string :context, limit: 128

      t.datetime :created_at
    end

    add_index :taggings, :tag_id
    add_index :taggings, [:taggable_id, :taggable_type, :context]


    ['social event', 'golf event', 'wedding', 'networking event', 'annual general meeting',
      'board meeting', 'business dinners & banquet', 'product launch', 'theme party',
      'conference', 'convention', 'fairs', 'galas', 'executive retreat', 'press conference', 'political event',
      'reception', 'seminar', 'trade show', 'workshop', 'bridal shower', 'baby shower', 'birthday'].map{|t| Tag.create(name: t.downcase, tag_type: 'event_type')}

    ['Convention Centres', 'Restaurants', 'Banquet Halls', 'Country Clubs',
      'Golf Clubs', 'Hotels', 'Office Buildings', 'Unique Venues'].map{|t| Tag.create(name: t.downcase, tag_type: 'venue_type')}

    ['A/V Equipment', 'Byob', 'Beachfront', 'Catering available', 'Coat check', 'Full bar', 'Great views',
      'Handicap accesible', 'Indoor', 'Media room', 'Non smoking', 'Pool', 'Rooftop', 'Parking', 'Theater', 'Wi-fi'].map{|t| Tag.create(name: t.downcase, tag_type: 'amenity')}
  end

  def self.down
    drop_table :taggings
    drop_table :tags
  end
end
