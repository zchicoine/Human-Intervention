# :description show data before saving
module ShowDataView
    class << self

        # :param [Hash]
        def new(data)
            Shoes::App.new width:610, hieght: 500 do
                data_to_be_saved = [] # array of hash TODO use me
                hash_data = {} # TODO use me
                stack do
                    background '#ffffff'
                    flow  do
                        subtitle em('User Email: '), size:20
                        subtitle data[:email_address],size:19, stroke: blue
                    end
                    flow  do
                        subtitle em('From: '), size:17
                        subtitle data[:from] ,size:12, stroke: blue
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
    end

end