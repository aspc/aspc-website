require 'httparty'
require 'watir'
require 'resolv-replace'

namespace :menu_import do
  desc "Imports All Menus"
  task :all => :environment do
    puts "Importing all menus..."

    tasks = [
        Rake::Task['menu_import:claremont_mckenna'],
        Rake::Task['menu_import:harvey_mudd'],
        Rake::Task['menu_import:pitzer'],
        Rake::Task['menu_import:scripps'],
        Rake::Task['menu_import:frary'],
        Rake::Task['menu_import:frank'],
        Rake::Task['menu_import:oldenborg']
    ]

    tasks.each { |t| t.invoke }
    puts "------"
  end

  desc "Imports Claremont McKenna Menu "
  task :claremont_mckenna => :environment do
    endpoint = 'http://legacy.cafebonappetit.com/api/2/menus'
    query = {
        :format => 'json',
        :cafe => '50',
        :date => _get_current_week().join(',')
    }

    puts "Importing Claremont McKenna Menu for week #{_get_current_week.first}..."

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

    puts "Successfully imported Claremont McKenna Menu for week #{_get_current_week.first}"
  end

  desc "Imports Pitzer Menu "
  task :pitzer => :environment do
    endpoint = 'http://legacy.cafebonappetit.com/api/2/menus'
    query = {
        :format => 'json',
        :cafe => '219',
        :date => _get_current_week().join(',')
    }

    puts "Importing Pitzer Menu for week #{_get_current_week.first}..."

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

    puts "Successfully imported Pitzer Menu for week #{_get_current_week.first}"
  end

  desc "Imports Harvey Mudd Menu "
  task :harvey_mudd => :environment do
    query = {
        :menuId => '344',
        :locationId => '13147001',
        :startDate => _get_current_week().second # Mudd menu weeks start on Monday
    }
    endpoint = 'https://menus.sodexomyway.com/BiteMenu/MenuOnly' + '?' + query.to_query.to_s

    puts "Importing Harvey Mudd Menu for week #{_get_current_week.first}..."

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

    puts "Successfully imported Harvey Mudd Menu for week #{_get_current_week.first}"
  end

  desc "Imports Scripps Menu"
  task :scripps => :environment do
    query = {
        :menuId => '288',
        :locationId => '10638001',
        :startDate => _get_current_week().second # Scripps menu weeks start on Monday
    }
    endpoint = 'https://menus.sodexomyway.com/BiteMenu/MenuOnly' + '?' + query.to_query.to_s

    puts "Importing Scripps Menu for week #{_get_current_week.first}..."

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

    puts "Successfully imported Scripps Menu for week #{_get_current_week.first}"
  end

  desc "Imports Frary Menu"
  task :frary => :environment do

    puts "Importing Frary Menu for week #{_get_current_week.first}..."

    # Clear any existing menus to avoid duplicates
    Menu.where(:dining_hall => :frary).destroy_all

    # Pomona's system is batshit crazy (user inputted text in Google Docs),
    # so we're just going to scrape from their website instead
    browser = Watir::Browser.new :chrome, headless: true
    browser.goto 'www.pomona.edu/administration/dining/menus/frary'

    menu = browser.div(:class => 'pom-accordion')
    meal_type = ''
    station = ''
    meal_menu = Menu

    menu_panels = menu.h3s(:class => 'ui-accordion-header')
    panel_count = 1 # the next panel to open

    # Map the successive divs to be pairs of {day, menu}
    menu.children.each_slice(2).map do |pair|
      {:day => pair[0].text.split(",")[0].downcase, :menu => pair[1] }
    end.each do |pair|
      # The menu for each day is structured as follows:
      #
      # meal type    (h2)
      # station      (h3)
      # menu items   (div)
      pair[:menu].children.each do |div|
        if div.tag_name == "h2"
          meal_type = div.text.downcase
          if (pair[:day] == 'saturday' || pair[:day] == 'sunday') && meal_type == 'breakfast'
            meal_type = 'brunch'
          end
        elsif div.tag_name == "h3"
          station = div.text
          hours = _get_pomona_hours('Frary', Date.strptime(pair[:day], '%A').wday, station)
          meal_menu = Menu.find_or_create_by(
            :day => pair[:day],
            :dining_hall => :frary,
            :meal_type => meal_type,
            :hours => hours
          )
        elsif div.tag_name == "div" && div.class_name == "nutrition-menu-section"
          div.children.each do |menu_item|
            MenuItem.create(:name => menu_item.p.text, :station => station, :menu => meal_menu)
          end
        end
      end
      # simulate click to open the next panel after parsing the current one
      menu_panels[panel_count].fire_event('click') unless panel_count > 6
      panel_count += 1
    end

    puts "Successfully imported Frary Menu for week #{_get_current_week.first}"

    browser.close
  end

  desc "Imports Frank Menu"
  task :frank => :environment do

    puts "Importing Frank Menu for week #{_get_current_week.first}..."

    # Clear any existing menus to avoid duplicates
    Menu.where(:dining_hall => :frank).destroy_all

    # Pomona's system is batshit crazy (user inputted text in Google Docs),
    # so we're just going to scrape from their website instead
    browser = Watir::Browser.new :chrome, headless: true
    browser.goto 'www.pomona.edu/administration/dining/menus/frank'

    menu = browser.div(:class => 'pom-accordion')
    meal_type = ''
    station = ''
    meal_menu = Menu

    menu_panels = menu.h3s(:class => 'ui-accordion-header')
    panel_count = 1 # the next panel to open

    # Map the successive divs to be pairs of {day, menu}
    menu.children.each_slice(2).map do |pair|
      {:day => pair[0].text.split(",")[0].downcase, :menu => pair[1] }
    end.each do |pair|
      # The menu for each day is structured as follows:
      #
      # meal type    (h2)
      # station      (h3)
      # menu items   (div)
      unless pair[:day] == 'friday' || pair[:day] == 'saturday'
        pair[:menu].children.each do |div|
          if div.tag_name == "h2"
            meal_type = div.text.downcase
            if pair[:day] == 'sunday' && meal_type == 'breakfast'
              meal_type = 'brunch'
            end
          elsif div.tag_name == "h3"
            station = div.text
            hours = _get_pomona_hours('Frank', Date.strptime(pair[:day], '%A').wday, station)
            meal_menu = Menu.find_or_create_by(
              :day => pair[:day],
              :dining_hall => :frank,
              :meal_type => meal_type,
              :hours => hours
            )
          elsif div.tag_name == "div" && div.class_name == "nutrition-menu-section"
            div.children.each do |menu_item|
              MenuItem.create(:name => menu_item.p.text, :station => station, :menu => meal_menu)
            end
          end
        end
      end
      # simulate click to open the next panel after parsing the current one
      menu_panels[panel_count].fire_event('click') unless panel_count > 6
      panel_count += 1
    end

    puts "Successfully imported Frank Menu for week #{_get_current_week.first}"

    browser.close
  end

  desc "Imports Oldenborg Menu"
  task :oldenborg => :environment do

    puts "Importing Oldenborg Menu for week #{_get_current_week.first}..."

    # Clear any existing menus to avoid duplicates
    Menu.where(:dining_hall => :oldenborg).destroy_all

    # Pomona's system is batshit crazy (user inputted text in Google Docs),
    # so we're just going to scrape from their website instead
    browser = Watir::Browser.new :chrome, headless: true
    browser.goto 'www.pomona.edu/administration/dining/menus/oldenborg'

    menu = browser.div(:class => 'pom-accordion')
    meal_type = ''
    station = ''
    meal_menu = Menu

    menu_panels = menu.h3s(:class => 'ui-accordion-header')
    panel_count = 1 # the next panel to open

    # Map the successive divs to be pairs of {day, menu}
    menu.children.each_slice(2).map do |pair|
      {:day => pair[0].text.split(",")[0].downcase, :menu => pair[1] }
    end.each do |pair|
      # The menu for each day is structured as follows:
      #
      # meal type    (h2)
      # station      (h3)
      # menu items   (div)
      unless pair[:day] == 'saturday' || pair[:day] == 'sunday'
        pair[:menu].children.each do |div|
          if div.tag_name == "h3"
            station = div.text
            hours = _get_pomona_hours('Oldenborg', Date.strptime(pair[:day], '%A').wday, station)
            meal_menu = Menu.find_or_create_by(
              :day => pair[:day],
              :dining_hall => :oldenborg,
              :meal_type => 'lunch',
              :hours => hours
            )
          elsif div.tag_name == "div" && div.class_name == "nutrition-menu-section"
            div.children.each do |menu_item|
              MenuItem.create(:name => menu_item.p.text, :station => station, :menu => meal_menu)
            end
          end
        end
      end
      # simulate click to open the next panel after parsing the current one
      menu_panels[panel_count].fire_event('click') unless panel_count > 6
      panel_count += 1
    end

    puts "Successfully imported Oldenborg Menu for week #{_get_current_week.first}"

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