require 'httparty'

namespace :menu_import do
  desc "Imports Claremont McKenna Menu "
  task :claremont_mckenna => :environment do
    endpoint = 'http://legacy.cafebonappetit.com/api/2/menus'
    query = {
        :format => 'json',
        :cafe => '50',
        :date => _get_current_week().join(',')
    }

    Rails.logger.info "Importing Claremont McKenna Menu for week #{_get_current_week.first}..."

    response = HTTParty.get(endpoint, :format => :json, :query => query).parsed_response

    food_id_to_names = response['items'] # Mapping for food ids -> food item names
    response['days'].each do |day|
      day_name = DateTime.parse(day['date']).strftime('%A').downcase # "Monday" --> "monday"

      all_meals = day['cafes']['50']['dayparts'][0]
      all_meals.each do |meal|
        meal_type = meal['label'].downcase

        next unless Menu.meal_types.keys.include? meal_type # Skip "Late Night" meal type

        cmc_menu = Menu.find_or_create_by(:day => day_name, :dining_hall => :claremont_mckenna, :meal_type => meal_type) # No duplicate menus
        cmc_menu.menu_items.destroy_all # No duplicate menu items

        stations = meal['stations']
        stations.each do |station|
          food_ids = station['items']
          food_ids.each do |food_id|

            # tiers 2+ display too much detail
            next unless food_id_to_names[food_id]['tier'] == 1

            station_name = station['label'].titleize
            food_name = food_id_to_names[food_id]['label'].capitalize
            MenuItem.create(:name => food_name, :station => station_name, :menu => cmc_menu)
          end
        end
      end
    end

    Rails.logger.info "Successfully imported Claremont McKenna Menu for week #{_get_current_week.first}"
  end

  desc "Imports Pitzer Menu "
  task :pitzer => :environment do
    endpoint = 'http://legacy.cafebonappetit.com/api/2/menus?format=json&cafe=219&date'
    query = {
        :format => 'json',
        :cafe => '219',
        :date => _get_current_week().join(',')
    }

    Rails.logger.info "Importing Pitzer Menu for week #{_get_current_week.first}..."

    response = HTTParty.get(endpoint, :format => :json, :query => query).parsed_response

    food_id_to_names = response['items'] # Mapping for food ids -> food item names
    response['days'].each do |day|
      day_name = DateTime.parse(day['date']).strftime('%A').downcase # "Monday" --> "monday"

      all_meals = day['cafes']['219']['dayparts'][0]
      all_meals.each do |meal|
        meal_type = meal['label'].downcase

        pitzer_menu = Menu.find_or_create_by(:day => day_name, :dining_hall => :pitzer, :meal_type => meal_type) # No duplicate menus
        pitzer_menu.menu_items.destroy_all # No duplicate menu items

        stations = meal['stations']
        stations.each do |station|
          food_ids = station['items']
          food_ids.each do |food_id|

            # tiers 2+ display too much detail
            next unless food_id_to_names[food_id]['tier'] == 1

            station_name = station['label'].titleize
            food_name = food_id_to_names[food_id]['label'].capitalize
            MenuItem.create(:name => food_name, :station => station_name, :menu => pitzer_menu)
          end
        end
      end
    end

    Rails.logger.info "Successfully imported Pitzer Menu for week #{_get_current_week.first}"
  end

  desc "Imports Harvey Mudd Menu "
  task :harvey_mudd => :environment do
    query = {
        :menuId => '344',
        :locationId => '13147001',
        :startDate => _get_current_week().second # Mudd menu weeks start on Monday
    }
    endpoint = 'https://menus.sodexomyway.com/BiteMenu/MenuOnly' + '?' + query.to_query.to_s

    Rails.logger.info "Importing Harvey Mudd Menu for week #{_get_current_week.first}..."

    # Mudd's menu is weird. The JSON is stored inside an HTML page, so we handle that mess here.
    menu_page = Nokogiri::HTML(open(endpoint))
    menu_week = JSON.parse menu_page.css('div#nutData').text

    # Destroy all existing menus to avoid duplicates
    Menu.where(:dining_hall => :harvey_mudd).destroy_all

    menu_week.each do |day|
      day_name = DateTime.parse(day['date']).strftime('%A').downcase # "Monday" --> "monday"

      menu_items = day['menuItems']
      menu_items.each do |menu_item|
        meal_type = menu_item['meal'].downcase

        mudd_menu = Menu.find_or_create_by(:day => day_name, :dining_hall => :harvey_mudd, :meal_type => meal_type) # No duplicate menus

        food_station = menu_item['course'].titleize
        food_name = menu_item['formalName']

        MenuItem.create(:name => food_name, :station => food_station, :menu => mudd_menu)

      end
    end

    Rails.logger.info "Successfully imported Harvey Mudd Menu for week #{_get_current_week.first}"
  end

  desc "Imports Scripps Menu"
  task :scripps => :environment do
    query = {
        :menuId => '288',
        :locationId => '10638001',
        :startDate => _get_current_week().second # Scripps menu weeks start on Monday
    }
    endpoint = 'https://menus.sodexomyway.com/BiteMenu/MenuOnly' + '?' + query.to_query.to_s

    Rails.logger.info "Importing Scripps Menu for week #{_get_current_week.first}..."

    # Mudd's menu is weird. The JSON is stored inside an HTML page, so we handle that mess here.
    menu_page = Nokogiri::HTML(open(endpoint))
    menu_week = JSON.parse menu_page.css('div#nutData').text

    # Destroy all existing menus to avoid duplicates
    Menu.where(:dining_hall => :scripps).destroy_all

    menu_week.each do |day|
      day_name = DateTime.parse(day['date']).strftime('%A').downcase # "Monday" --> "monday"

      menu_items = day['menuItems']
      menu_items.each do |menu_item|
        meal_type = menu_item['meal'].downcase.split('/')[0] # lunch/brunch ==> lunch

        scripps_menu = Menu.find_or_create_by(:day => day_name, :dining_hall => :scripps, :meal_type => meal_type) # No duplicate menus

        food_station = menu_item['course'].titleize
        food_name = menu_item['formalName']

        MenuItem.create(:name => food_name, :station => food_station, :menu => scripps_menu)

      end
    end

    Rails.logger.info "Successfully imported Scripps Menu for week #{_get_current_week.first}"
  end

  def _get_current_week
    week = []
    today = Date.today.wday
    sunday = Date.today - today # Get the current sunday for the week

    (0..6).each do |i|
      date = sunday + i
      week << date.iso8601
    end

    week
  end
end