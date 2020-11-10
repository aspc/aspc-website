require 'rails_helper'

class HelloWorld
    def say_hello
        "Hello World!"
    end 
end 


RSpec.describe HelloWorld do
    context "When testing the HelloWorld class" do 
        it "Should run" do
            hw = HelloWorld.new 
            message = hw.say_hello
            expect(message).to eq "Hello World!"
        end 
    end 
end 