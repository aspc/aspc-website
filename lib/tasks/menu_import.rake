require 'httparty'
require 'watir'
require 'resolv-replace'

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

    # Destroy all existing menus to avoid duplicates
    Menu.where(:dining_hall => :claremont_mckenna).destroy_all

    response = HTTParty.get(endpoint, :format => :json, :query => query).parsed_response

    food_id_to_names = response['items'] # Mapping for food ids -> food item names
    response['days'].each do |day|
      day_name = DateTime.parse(day['date']).strftime('%A').downcase # "Monday" --> "monday"

      all_meals = day['cafes']['50']['dayparts'][0]
      all_meals.each do |meal|
        meal_type = meal['label'].downcase

        # Select hours and minutes from date and time and convert it to 12-hour clock format
        starttime = Time.parse(meal['starttime']).strftime('%l:%M%p').strip
        endtime = Time.parse(meal['endtime']).strftime('%l:%M%p').strip
        hours = starttime << '-' << endtime

        next unless Menu.meal_types.keys.include? meal_type # Skip "Late Night" meal type

        cmc_menu = Menu.find_or_create_by(:day => day_name, :dining_hall => :claremont_mckenna, :meal_type => meal_type, :hours => hours) # No duplicate menus
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
    endpoint = 'http://legacy.cafebonappetit.com/api/2/menus'
    query = {
        :format => 'json',
        :cafe => '219',
        :date => _get_current_week().join(',')
    }

    Rails.logger.info "Importing Pitzer Menu for week #{_get_current_week.first}..."

    # Destroy all existing menus to avoid duplicates
    Menu.where(:dining_hall => :pitzer).destroy_all

    response = HTTParty.get(endpoint, :format => :json, :query => query).parsed_response

    food_id_to_names = response['items'] # Mapping for food ids -> food item names
    response['days'].each do |day|
      day_name = DateTime.parse(day['date']).strftime('%A').downcase # "Monday" --> "monday"

      all_meals = day['cafes']['219']['dayparts'][0]
      all_meals.each do |meal|
        meal_type = meal['label'].downcase

        # Select hours and minutes from date and time and convert it to 12-hour clock format
        starttime = Time.parse(meal['starttime']).strftime('%l:%M%p').strip
        endtime = Time.parse(meal['endtime']).strftime('%l:%M%p').strip
        hours = starttime << '-' << endtime

        pitzer_menu = Menu.find_or_create_by(:day => day_name, :dining_hall => :pitzer, :meal_type => meal_type, :hours => hours) # No duplicate menus
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

        # Select hours and minutes from date and time and convert it to 12-hour clock format
        starttime = Time.parse(menu_item['startTime'][/\d\d:\d\d/, 0]).strftime('%l:%M%p').strip
        endtime = Time.parse(menu_item['endTime'][/\d\d:\d\d/, 0]).strftime('%l:%M%p').strip
        hours = starttime << '-' << endtime

        mudd_menu = Menu.find_or_create_by(:day => day_name, :dining_hall => :harvey_mudd, :meal_type => meal_type, :hours => hours) # No duplicate menus

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
        meal_type = menu_item['meal'].downcase.split('/')
        if meal_type.length == 2
          meal_type = meal_type[1] # lunch/brunch ==> brunch
        else
          meal_type = meal_type[0]
        end
        hours = menu_item['startTime'][/\d\d:\d\d/, 0] << '-' << menu_item['endTime'][/\d\d:\d\d/, 0] # Select hours and minutes from date and time

        # Select hours and minutes from date and time and convert it to 12-hour clock format
        starttime = Time.parse(menu_item['startTime'][/\d\d:\d\d/, 0]).strftime('%l:%M%p').strip
        endtime = Time.parse(menu_item['endTime'][/\d\d:\d\d/, 0]).strftime('%l:%M%p').strip
        hours = starttime << '-' << endtime

        scripps_menu = Menu.find_or_create_by(:day => day_name, :dining_hall => :scripps, :meal_type => meal_type, :hours => hours) # No duplicate menus

        food_station = menu_item['course'].titleize
        food_name = menu_item['formalName']

        MenuItem.create(:name => food_name, :station => food_station, :menu => scripps_menu)

      end
    end

    Rails.logger.info "Successfully imported Scripps Menu for week #{_get_current_week.first}"
  end

  desc "Imports Frary Menu"
  task :frary => :environment do

    Rails.logger.info "Importing Frary Menu for week #{_get_current_week.first}..."

    # Clear any existing menus to avoid duplicates
    Menu.where(:dining_hall => :frary).destroy_all

    # Pomona's system is batshit crazy (user inputted text in Google Docs),
    # so we're just going to scrape from their website instead
    #
    # Menu Format
    #
    # | Day                                   |
    # | Station |  Breakfast | Lunch | Dinner |

    browser = Watir::Browser.new :chrome, headless: true
    browser.goto 'www.pomona.edu/administration/dining/menus/frary'

    menu_panels = browser.div(:id => 'menu-from-google').divs(:class => ['table-caption', 'hide'])
    menu_panels.each do |panel| # Fire off the click request to load the menu for that day
      panel.click
    end

    menu_days = browser.div(:id => 'menu-from-google').elements(:tag_name => 'table')
    menu_days.each_with_index do |day_table, day_index|
      day_table.each_with_index do |station_row, row_index| # food is ordered by station then meal type
        next if row_index == 0 # skip header row

        station = station_row[0].try(:text)

        next if station.blank? # no need to continue if cell is empty

        station_row.each_with_index do |meal_for_station, meal_type_index|
          next if meal_type_index == 0

          if not meal_for_station.text.blank?
            day = (day_index + 1) % 7 # Frank/Frary menus are indexed starting on Monday, not Sunday

            # Frary splits Sunday brunch into breakfast and lunch; manually combine the two on Sundays
            if day == 0 && (meal_for_station.class_name == "breakfast" || meal_for_station.class_name == "lunch")
              hours = _get_pomona_hours("Frary", day, "brunch")
              meal_menu = Menu.find_or_create_by(:day => day, :dining_hall => :frary, :meal_type => "brunch", :hours => hours)
            else
              hours = _get_pomona_hours("Frary", day, meal_for_station.class_name)
              meal_menu = Menu.find_or_create_by(:day => day, :dining_hall => :frary, :meal_type => meal_for_station.class_name, :hours => hours)
            end
            
            meal_for_station.text.split(',').each do |meal_item|
              MenuItem.create(:name => meal_item, :station => station, :menu => meal_menu)
            end
          end
        end
      end
    end

    Rails.logger.info "Successfully imported Frary Menu for week #{_get_current_week.first}"

    browser.close
  end

  desc "Imports Frank Menu"
  task :frank => :environment do

    Rails.logger.info "Importing Frank Menu for week #{_get_current_week.first}..."

    # Clear any existing menus to avoid duplicates
    Menu.where(:dining_hall => :frank).destroy_all

    # Pomona's system is batshit crazy (user inputted text in Google Docs),
    # so we're just going to scrape from their website instead
    #
    # Menu Format
    #
    # | Day                                   |
    # | Station |  Breakfast | Lunch | Dinner |

    browser = Watir::Browser.new :chrome, headless: true
    browser.goto 'www.pomona.edu/administration/dining/menus/frank'

    menu_panels = browser.div(:id => 'menu-from-google').divs(:class => ['table-caption', 'hide'])
    menu_panels.each do |panel| # Fire off the click request to load the menu for that day
      panel.click
    end

    menu_days = browser.div(:id => 'menu-from-google').elements(:tag_name => 'table')
    menu_days.each_with_index do |day_table, day_index|
      day_table.each_with_index do |station_row, row_index| # food is ordered by station then meal type
        next if row_index == 0 # skip header row

        station = station_row[0].try(:text)

        next if station.blank? # no need to continue if cell is empty

        # Frank is closed on Fri/Sat, so don't load those days

        station_row.each_with_index do |meal_for_station, meal_type_index|
          next if meal_type_index == 0

          if not meal_for_station.text.blank?
            day = (day_index + 1) % 7 # Frank/Frary menus are indexed starting on Monday, not Sunday
            hours = _get_pomona_hours('Frank', day, meal_for_station.class_name)
            meal_menu = Menu.find_or_create_by(:day => day, :dining_hall => :frank, :meal_type => meal_for_station.class_name, :hours => hours)

            meal_for_station.text.split(',').each do |meal_item|
              MenuItem.create(:name => meal_item, :station => station, :menu => meal_menu)
            end
          end
        end
      end
    end

    Rails.logger.info "Successfully imported Frank Menu for week #{_get_current_week.first}"

    browser.close
  end

  desc "Imports Oldenborg Menu"
  task :oldenborg => :environment do

    Rails.logger.info "Importing Oldenborg Menu for week #{_get_current_week.first}..."

    # Clear any existing menus to avoid duplicates
    Menu.where(:dining_hall => :oldenborg).destroy_all

    # Pomona's system is batshit crazy (user inputted text in Google Docs),
    # so we're just going to scrape from their website instead
    #
    # Menu Format
    #
    # | Day                                   |
    # | Station |  Breakfast | Lunch | Dinner |

    browser = Watir::Browser.new :chrome, headless: true
    browser.goto 'www.pomona.edu/administration/dining/menus/oldenborg'

    menu_panels = browser.div(:id => 'menu-from-google').divs(:class => ['table-caption', 'hide'])
    menu_panels.each do |panel| # Fire off the click request to load the menu for that day
      panel.click
    end

    menu_days = browser.div(:id => 'menu-from-google').elements(:tag_name => 'table')
    menu_days.each_with_index do |day_table, day_index|
      day_table.each_with_index do |station_row, row_index| # food is ordered by station then meal type
        next if row_index == 0 # skip header row

        station = station_row[0].try(:text)

        next if station.blank? # no need to continue if cell is empty

        station_row.each_with_index do |meal_for_station, meal_type_index|
          next if meal_type_index == 0

          if not meal_for_station.text.blank?
            day = (day_index + 1) % 7 # Frank/Frary menus are indexed starting on Monday, not Sunday
            hours = _get_pomona_hours('Oldenborg', day, meal_for_station.class_name)
            meal_menu = Menu.find_or_create_by(:day => day, :dining_hall => :oldenborg, :meal_type => meal_for_station.class_name, :hours => hours)

            meal_for_station.text.split(',').each do |meal_item|
              MenuItem.create(:name => meal_item, :station => station, :menu => meal_menu)
            end
          end
        end
      end
    end

    Rails.logger.info "Successfully imported Oldenborg Menu for week #{_get_current_week.first}"

    browser.close
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

  # This is a temporary solution for Pomona dining hall hours as scarping pomona.edu is not working at the moment
  def _get_pomona_hours(dining_hall, day, meal_type)
    case dining_hall
    when 'Frary'
      case day
      when 1..5
        case meal_type
        when 'breakfast'
          hours = '7:30AM-10:00AM'
          hours
        when 'lunch'
          hours = '11:00AM-2:00PM'
          hours
        when 'dinner'
          hours = '5:00PM-8:00PM'
          hours
        end
      when 0, 6
        case meal_type
        when 'breakfast'
          hours = '8:00AM-10:30AM'
          hours
        when 'brunch'
          hours = '10:30AM-1:30PM'
        when 'dinner'
          hours = '5:00PM-8:00PM'
          hours
        end
      end
    when 'Frank'
      case day
      when 1..4
        case meal_type
        when 'breakfast'
          hours = '7:30AM-10:00AM'
          hours
        when 'lunch'
          hours = '11:00AM-1:00PM'
          hours
        when 'dinner'
          hours = '5:00PM-7:00PM'
          hours
        end
      when 0
        case meal_type
        when 'brunch'
          hours = '11:00AM-1:00PM'
          hours
        when 'dinner'
          hours = '5:00PM-7:00PM'
          hours
        end
      end
    when 'Oldenborg'
      case day
      when 1..5
        case meal_type
        when 'lunch'
          hours = '12:00AM-1:00PM'
          hours
        end
      end
    end
  end
end