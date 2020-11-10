require 'rspec/rails'
require 'rails_helper'

describe Event do
    context "Event methods" do
        it "can approve" do
            @event = Event.new(name: "Sample event", start: DateTime.new, end: DateTime.new, location: "Online", description: "Something")
            @event.approve!
            expect(@event.status).to eq "approved"
        end 

        it "can  decline" do
            @event = Event.new(name: "Sample event", start: DateTime.new, end: DateTime.new, location: "Online", description: "Something")
            @event.reject!
            expect(@event.status).to eq "rejected"
        end 

    end 


end 
