require 'date'
require 'Data_Controller'
require_relative 'UI/show_data_view'
require_relative 'UI/emails_ui'

Shoes.app title: 'Human Intervention', width: 1210, height: 660, resizable: false do

    email_ui = EmailOperations::UI.new(self)
    @shipments = [] # keep the shipment information such as Ship and port name and Date

    email_ui.email_list
    email_ui.email_box
    # ==================== START OF INPUT DATA ==================== #
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
                    unless email_ui.email_hash[:email_address].nil?
                        @shipments.push({ship:@ship.text, port:@port.text, :date => Date.parse(@date.text).strftime("%Y/%m/%d")})
                        email_ui.email_hash[:shipments] = @shipments
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
                        email_ui.email_hash[:shipments] = @shipments
                    end
                end
            end
        }
        button('Show data',left:100) do
            unless email_ui.email_hash[:shipments].nil? or email_ui.email_hash[:email_object].nil?

                ShowDataView.new(email_ui.email_hash)
            end
        end

    end
    # ==================== END OF Input Data ==================== #

end

#####================ USEFUL CODE ================#####
#  para "Enter a URL to download:", margin: [10, 8, 10, 0]

# keypress do |key|
# s.append do para 'You pressed ' + key.to_s end
# p key
# end

# list_box items: ["Jack", "Ace", "Joker"]
#####================ END USEFUL CODE ================#####