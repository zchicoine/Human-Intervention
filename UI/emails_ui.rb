require_relative '../backend/emails_backend'
require 'shoes'


module EmailOperations
    class UI
        attr_reader :email_hash

        def initialize(appGui)
            @app = appGui
            @list = [] # keep the list of emails
            @text_box = nil

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
        def delete_an_email
            if @app.confirm('Are you sure, cannot be undo')
                @app.alert  @email_hash[:email_object]
            end
        end
        def mark_an_email_as_reviewed
            @app.alert @email_hash[:email_object]
        end

        private
        # :description it is called when the fetch button clicked
        # :param [Shoes::TextBlock,TextBox] the method will modify the TextBox.text
        def fetch_button_click
            EmailOperations::Backend.fetch_emails_all.zip(@list).each do |fetch_email,list|
                list.replace(@app.link(fetch_email.email_address) {
                                 @email_hash[:email_object] = fetch_email
                                 @email_hash[:email_address] = fetch_email.email_address
                                 @email_hash[:from] = fetch_email.from
                                 @email_hash[:email_text] = fetch_email.show
                                 @text_box.text = @email_hash[:email_text]
                             },
                             "\t \t ",
                             @app.link('Delete', size: 12) {
                                delete_an_email
                             }
                )
            end
        end

    end
end