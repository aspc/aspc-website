namespace :housing_import do
  desc "Imports housing buildings"
  task :buildings => :environment do
    HousingBuilding.destroy_all

    Rails.logger.info "Loading old rooms from college_building.json"
    file_path = Rails.root.join('lib', 'tasks', 'shared', 'college_building.json')
    file = File.read(file_path)
    buildings = JSON.parse(file)


    buildings.each do |info|
      puts info

      building = HousingBuilding.new(
        :name => info['name']
      )

      building.id = info['id']
      building.save!

      if building.id != info['id']
        building.destroy!
      else
        building.save
      end
    end
  end

  desc "Imports housing rooms"
  task :rooms => :environment do
    HousingRoom.destroy_all

    Rails.logger.info "Loading old rooms from housing_room.json"
    file_path = Rails.root.join('lib', 'tasks', 'shared', 'housing_room.json')
    file = File.read(file_path)
    rooms = JSON.parse(file)

    # Contains pairings of (room_id, building_id, building_name, room_number)
    linkage_file_path = Rails.root.join('lib', 'tasks', 'shared', 'linkage.json')
    linkage_file = File.read(linkage_file_path)
    linkage = JSON.parse(linkage_file)

    rooms.each do |info|
      puts info

      room = HousingRoom.new(
          :size => info['size'] || 0,
          :occupancy_type => info['occupancy']
      )

      room.id = info['roomlocation_ptr_id']
      room.room_number = linkage[room.id.to_s]['number']
      room.housing_building_id = linkage[room.id.to_s]['building_id']

      if room.save
        if room.id != info['roomlocation_ptr_id']
          room.destroy!
        end
      else
        puts "Failed to save #{room.inspect}"
      end
    end
  end

  desc "Imports housing reviews"
  task :reviews => :environment do
    HousingReview.destroy_all

    Rails.logger.info "Loading old reviews from housing_review.json"
    file_path = Rails.root.join('lib', 'tasks', 'shared', 'housing_review.json')
    file = File.read(file_path)
    reviews = JSON.parse(file)

    # Contains pairings of (room_id, building_id, building_name, room_number)
    # linkage_file_path = Rails.root.join('lib', 'tasks', 'shared', 'linkage.json')
    # linkage_file = File.read(linkage_file_path)
    # linkage = JSON.parse(linkage_file)

    reviews.each do |info|
      puts info

      review = HousingReview.new(
          :overall_rating => info['overall'] || 0,
          :quiet_rating => info['quiet'] || 0,
          :layout_rating => info['spacious'] || 0,
          :temperature_rating => info['temperate'] || 0,
          :comments => "#{info['best']} #{info['worst']} #{info['comments']}"
      )

      review.housing_room_id = info['room_id']

      if not review.save
        puts "Failed to save #{review.inspect}"
      end
    end
  end
end