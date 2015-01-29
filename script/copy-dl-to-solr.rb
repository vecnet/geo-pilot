#!/usr/bin/env ruby

require 'rsolr'

# usage:
# $ copy-dl-to-solr.rb [source solr url] [target solr url]

if ARGV.length != 2
  puts "USAGE:"
  puts "copy-dl-to-solr.rb [source solr url] [target solr url]"
  exit 1
end

puts "Source is #{ARGV[0]}"
puts "Target is #{ARGV[1]}"

source = RSolr.connect url: ARGV[0]
target = RSolr.connect url: ARGV[1]

response = source.get 'select', params: {q: '*:vecnet', rows: 1000}

def first_or_nil(lst)
  return nil if lst.nil?
  lst.first
end

processed_count = 0

response['response']['docs'].each do |record|
  puts "Processing record #{record['id']}"
  new_record = {
    uuid:             record['id'],
    dc_title_s:       first_or_nil(record['desc_metadata__title_t']),
    dc_description_s: first_or_nil(record['desc_metadata__description_t']),
    dc_creator_sm:    record['desc_metadata__creator_t'],
    dc_type_s:        first_or_nil(record['desc_metadata__resource_type_t']),
    # these are required ATM for geoblacklight...
    layer_id_s:       first_or_nil(record['noid_s']),
    layer_slug_s:     first_or_nil(record['noid_s']),
    layer_geom_type_s: 'Point',
    dct_provenance_s: 'Digital Library',
    dc_rights_s:      first_or_nil(record['read_access_group_t']) || 'Public'
  }

  target.add new_record
  processed_count += 1
end

target.commit

puts "Processed #{processed_count} records"
