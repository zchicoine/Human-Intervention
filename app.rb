require 'date'
class Email

    attr_reader :body, :subject , :from, :date, :email_address


    #: param [Hash] {subject:,body:,from:,date:,email_address}
    def initialize(email)
        @body = email[:body]
        @subject = email[:subject]
        @from = email[:from]
        @date = email[:date]
        @email_address = email[:email_address]

    end

    def body
        @body
    end
    def subject
        @subject
    end
    def from
        @from
    end

    def date
        @date
    end
    def email_address
        @email_address
    end
    def show
        " Email Address: #{email_address}\n Subject: #{subject} \n From: #{from} \n Date: #{date} \n\n--------------------------- \n Body: #{body}
        \n"
    end
end

fetch_email = Class.new do
    # :return [Array] of emails
    def all
        emails = []

        #sample
        10.times do
            emails.push(Email.new({body:'email body', subject:'email subject', date:'12 may', from:'email@address.com', email_address:'my@broker.ca'}))
        end
        emails
    end
end.new

Shoes.app title: 'Human Intervention', width: 1300, height: 660, resizable: false do

    @current_email = {} # keep all the information need to be save to master website
    @shipment = [] # keep the shipment information such as Ship and port name and Date
    stack  height:650  , width: 300  do
        border "#ffffff", strokewidth: 2, curve: 12
        button('Fetch')  do
            fetch_email.all.each do |email|
                para "\n"
                para link(email.email_address) {
                         @current_email[:email_address] = email.email_address
                         @current_email[:email] = email.show
                         @email_box.text = @current_email[:email]
                     },"\t \t ",link('Delete') {

                      }
            end
        end
    end
    stack margin_left: 5, margin_top: 5, height:650, width:600, scroll: true  do
        border "#ffffff", strokewidth: 1, curve: 12
        @email_box = edit_box '',  margin: 5, height:640, width:590

    end
    stack margin_left: 5, margin_top: 5, height:650, width:300, scroll: true  do
        border "#ffffff", strokewidth: 1, curve: 12
        para 'Ship name'
        flow do
            @ship = edit_line(width: 120)
        end
        para 'Port name'
        flow do
            @port = edit_line(width: 120)
        end
        para 'Date yyyy/mm/dd'
        flow do
            @date =  edit_line(width: 120)
        end
        flow(width: 300) {
            button('clear') do
                @ship.text = ''
                @date.text = ''
                @port.text = ''

            end
            button 'Add to List' do
                begin
                    @shipment.push({ship:@ship.text, port:@port.text, :date => Date.parse(@date.text).strftime("%Y/%m/%d")})
                    @current_email[:shipment] = @shipment
                    @ship.text = ''
                    @date.text = ''
                    @port.text = ''
                rescue ArgumentError => e
                    alert e
                end
            end
            button 'Save to DB' do
                alert "#{@current_email[:shipment] } #{@current_email[:email_address]}"
            end
        }
    end
end



##### useful code

#  para "Enter a URL to download:", margin: [10, 8, 10, 0]

#  button "Download", width: 120 do
#  end

#  ship = edit_line width: 150
#  ship.text

# keypress do |key|
# s.append do para 'You pressed ' + key.to_s end
# p key
# end