ENV["RAILS_ENV"] ||= 'spec'
require File.expand_path("../../config/environments",__FILE__)
require 'rspec/rails'
require 'rspec/autorun'