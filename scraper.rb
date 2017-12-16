#!/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

require 'pry'
require 'scraperwiki'
require 'wikidata/fetcher'
require 'wikidata/area'

query = <<QUERY
  SELECT DISTINCT ?item ?itemLabel
  WHERE
  {
    { ?item wdt:P31 wd:Q41806065 } UNION { ?item wdt:P31 wd:Q2914565 }.
  }
QUERY

wanted = EveryPolitician::Wikidata.sparql(query)
raise 'No ids' if wanted.empty?

ScraperWiki.sqliteexecute('DELETE FROM data') rescue nil
data = Wikidata::Areas.new(ids: wanted).data
ScraperWiki.save_sqlite(%i(id), data)
