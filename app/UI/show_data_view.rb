require_relative '../backend/emails_backend'
# :description show data before saving
module ShowDataView
    class << self

        # :param [Hash]
        def new(data)
            Shoes::App.new width:610, hieght: 500 do
                shipments_to_be_saved = [] # array of hash
                hash_data = {}
                hash_data[:body] = data[:email_object].body
                hash_data[:subject] = data[:email_object].subject
                hash_data[:email_date] = data[:email_object].date
                hash_data[:email_address] = data[:email_address]
                hash_data[:from] = data[:from]
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
                            hash_shipment = {}
                            tagline strong('Ship: '), left:0
                            hash_shipment[:ship] = edit_line(shipment[:ship], width:120, left:50)
                            tagline strong('Port: '),  left:200
                            hash_shipment[:port] = edit_line(shipment[:port], width:120, left:250)
                            # Date.parse(shipment[:date])
                            tagline strong('Date: '),  left:400
                            hash_shipment[:date] = edit_line(shipment[:date], width:120, left:450)
                            hash_shipment[:save] = check(left:585)
                            hash_shipment[:save].checked = true
                            para "\n"
                            shipments_to_be_saved.push(hash_shipment)
                        end
                    end
                end
                flow do
                    button 'Cancel' do
                        close
                    end
                    button 'Save to DB' do
                        if confirm('Are you sure, cannot be undo')
                            #{email:{status:'succ',body:,subject:,from:,email_address,etc}, ship_info:[{ship_name:,port_name:,open_date:},etc]}
                            _send_to_db = {
                                email: {
                                    status:'succ',
                                    body: hash_data[:body],
                                    subject:hash_data[:subject],
                                    from:hash_data[:from],
                                    email_address:hash_data[:email_address]
                                    },
                                ship_info:[]
                            }
                            shipments_to_be_saved.each do |shipment|
                                if shipment[:save].checked?
                                   p shipment[:save]
                                    _send_to_db[:ship_info].push({ship_name:shipment[:ship].text.to_s,port_name:shipment[:port].text.to_s,open_date:Date.parse(shipment[:date].text.to_s)})
                                end
                            end
                            result = EmailOperations::Backend.save_data_to_mainDB(_send_to_db)
                            if result[:error].nil?
                                alert "It has been successfully saved \n \n #{_send_to_db[:ship_info]}"
                           else
                                alert result
                           end
                        end
                    end
                end

            end
        end
    end

end