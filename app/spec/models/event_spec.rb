


describe Event do
    context "Event methods" do
        it "can approve" do
            @event = Event.new()
            @event.approve 
            expect(@event.status).to eq :approved
        end 

        it "can  decline" do 
            @event = Event.new
            @event.reject
            exoect(@event.status).to eq :rejected
        end 

    end 


end 