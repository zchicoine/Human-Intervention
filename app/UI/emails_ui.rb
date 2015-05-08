require_relative '../backend/emails_backend'


module EmailOperations
    class UI
        attr_reader :email_hash

        def initialize(appGui)
            @app = appGui
            @list = [] # keep the list of emails with their UIs
            @list_of_fetch_emails = []
            @text_box = nil
            @email_to_fetch = nil # specify the email to be retrieve from the server
            # keep all the information need to be save to master website
            @email_hash = {
                email_object: nil, # object of [EmailOperations::Backend::Email] class
                email_address:'', # user email address
                from:'', # email address sent from
                email_text:'', # friendly format to display
                shipments:[] # array of the keep information ship, port and date
            }
        end

        def email_list
            @app.stack  height:650  , width: 300  do
                @app.border "#ffffff", strokewidth: 2, curve: 12
                @app.button('Fetch')  do
                    fetch_button_click
                end
                @email_to_fetch = @app.edit_line '', top:5, left: 100, width: 180, hieght:15
                10.times do |i|
                    @app.para ''
                    @list.push(@app.tagline(size:15) )
                end
            end
        end

        def email_box
            @app.stack margin_left: 5, margin_top: 5, height:650, width:600, scroll: true  do
                @app.border "#ffffff", strokewidth: 1, curve: 12
                @text_box = @app.edit_box '',  margin: 5, height:640, width:590

            end
        end

        # :description delete the email from the server
        # :return [Boolean] true if it has been deleted, false otherwise
        def delete
            if @app.confirm('Are you sure, cannot be undo')
                EmailOperations::Backend.delete_an_email(@email_hash[:email_object].key,@email_hash[:email_object].email_address)
                @app.alert  "#{@email_hash[:email_object].email_address} has been deleted"
                return true
            end
            false
        end
        def mark_an_email_as_reviewed
            @app.alert @email_hash[:email_object]
        end

        private
        # :description it is called when the fetch button clicked
        # :param [Shoes::TextBlock,TextBox] the method will modify the TextBox.text
        def fetch_button_click
            @list_of_fetch_emails =  EmailOperations::Backend.fetch_emails_all(@email_to_fetch.text.to_s)
            update_emails_list
        end

        def update_emails_list
            @list.each {|list| list.replace('')} # delete all info
            @list_of_fetch_emails.zip(@list).each do |fetch_email,list|
                list.replace(@app.link(fetch_email.email_address) {
                                 @email_hash[:email_object] = fetch_email
                                 @email_hash[:email_address] = fetch_email.email_address
                                 @email_hash[:from] = fetch_email.from
                                 @email_hash[:email_text] = fetch_email.show
                                 @text_box.text = @email_hash[:email_text]
                             },
                             "\t \t ",
                             @app.link('Delete', size: 12) {
                                 @email_hash[:email_object] = fetch_email
                                 if delete
                                     @list_of_fetch_emails.delete(fetch_email)
                                     update_emails_list
                                 end
                             }
                )
            end
        end
    end
end