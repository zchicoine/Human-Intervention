require 'date'
require_relative 'emails'

# :description it is called when the fetch button clicked
def fetch_button_click(emails_list)
    EmailOperations.fetch_emails_all.zip(emails_list).each do |fetch_email,list|
        list.replace(link(fetch_email.email_address) {
                         @current_email[:email_address] = fetch_email.email_address
                         @current_email[:email] = fetch_email.show
                         @email_box.text = @current_email[:email]
                     },
                     "\t \t ",
                      link('Delete', size: 12) {
                          delete_an_email(fetch_email)
                      }
        )
    end
end
def delete_an_email(email)
    if confirm('Are you sure, cannot be undo')
        alert email
    end
end
def mark_an_email_as_reviewed(email)
    alert email
end

Shoes.app title: 'Human Intervention', width: 1300, height: 660, resizable: false do

    @current_email = {} # keep all the information need to be save to master website
    @shipment = [] # keep the shipment information such as Ship and port name and Date
    @emails_list = [] # keep the list of emails

    # stack to show emails as a list
    stack  height:650  , width: 300  do
        border "#ffffff", strokewidth: 2, curve: 12
        button('Fetch')  do
            fetch_button_click(@emails_list)
        end
        10.times do |i|
            para "\n"
           @emails_list.push(tagline )
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

# list_box items: ["Jack", "Ace", "Joker"]