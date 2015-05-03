require 'date'
require_relative 'emails'

# :description it is called when the fetch button clicked
# :param [Shoes::TextBlock]
def fetch_button_click(emails_list)
    EmailOperations.fetch_emails_all.zip(emails_list).each do |fetch_email,list|
        list.replace(link(fetch_email.email_address) {
                         @current_email[:email_address] = fetch_email.email_address
                         @current_email[:from] = fetch_email.from
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
# :description show data before saving
# :param [Hash]
def show_data(data)
    window width:610, hieght: 500 do
        data_to_be_saved = [] # array of hash TODO use me
        hash_data = {} # TODO use me
        stack do
            background '#ffffff'
            flow  do
                subtitle em('User Email: '), size:20
                subtitle data[:email_address],size:19, stroke: red
            end
            flow  do
                subtitle em('From: '), size:17
                subtitle data[:from] ,size:12, stroke: red
            end
            tagline "\n"
            data[:shipments].each do |shipment|
                flow  scroll: true do
                    tagline strong('Ship: '), left:0
                    edit_line(shipment[:ship], width:120, left:50)
                    tagline strong('Port: '),  left:200
                    edit_line(shipment[:port], width:120, left:250)
                    tagline strong('Date: '),  left:400
                    edit_line(shipment[:date], width:120, left:450)
                    check(left:585).checked = true
                    para "\n"
                end
            end
        end
        flow do
            button 'Cancel' do
                close
            end
            button 'Save to DB' do
                alert 'saved successfully'
            end
        end

    end
end

Shoes.app title: 'Human Intervention', width: 1210, height: 660, resizable: false do

    @current_email = {} # keep all the information need to be save to master website
    @shipments = [] # keep the shipment information such as Ship and port name and Date
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
    # ==================== END OF EMAILS LIST ==================== #

    stack margin_left: 5, margin_top: 5, height:650, width:600, scroll: true  do
        border "#ffffff", strokewidth: 1, curve: 12
        @email_box = edit_box '',  margin: 5, height:640, width:590

    end
    # ==================== END OF EMAIL box ==================== #

    stack margin_left: 5, margin_top: 5, height:650, width:300, scroll: true  do
        border "#ffffff", strokewidth: 1, curve: 12

        flow do
            para 'Ship name' , left: 10, top: 10
            @ship = edit_line(width: 120, right: 5, top: 5)
        end
        flow do
            para 'Port name' , left: 10, top: 10
            @port = edit_line(width: 120,right: 5,top: 5)
        end
        flow do
            para 'Date yyyy/mm/dd' , left: 10 ,top: 10
            @date =  edit_line(width: 120, right: 5,  top: 5)
        end
        flow(width: 300) {
            button('Add to List', right:30, top:15) do
                begin
                    unless @current_email[:email_address].nil?
                        @shipments.push({ship:@ship.text, port:@port.text, :date => Date.parse(@date.text).strftime("%Y/%m/%d")})
                        @current_email[:shipments] = @shipments
                        @ship.text = ''
                        @date.text = ''
                        @port.text = ''
                    end
                rescue ArgumentError => e
                    alert e
                end
            end
            button('Clear the List', left:15, top:16) do
                if confirm('Are you sure, cannot be undo')
                    unless @shipments.nil?
                        @shipments = []
                        @current_email[:shipments] = @shipments
                    end
                end
            end
        }
        button('Show data',left:100) do
            unless @current_email[:shipments].nil?
                show_data(@current_email)
            end
        end

    end


    # ==================== END OF EMAIL box ==================== #



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