require_relative '../backend/emails_backend'
require 'shoes'


module EmailOperations
    class UI
        # sfg
        attr_reader :email_hash

        def initialize
            # keep all the information need to be save to master website
            @email_hash = {
                email_object: nil, # object of [EmailOperations::Backend::Email] class
                email_address:'', # user email address
                from:'', # email address sent from
                email_text:'', # friendly format to display
                shipments:[] # array of the keep information ship, port and date
            }
        end


        # :description it is called when the fetch button clicked
        # :param [Shoes::TextBlock,TextBox] the method will modify the TextBox.text
        def fetch_button_click!(emails_list,email_box,app)
            EmailOperations::Backend.fetch_emails_all.zip(emails_list).each do |fetch_email,list|
                list.replace(app.link(fetch_email.email_address) {
                                 @email_hash[:email_object] = fetch_email
                                 @email_hash[:email_address] = fetch_email.email_address
                                 @email_hash[:from] = fetch_email.from
                                 @email_hash[:email_text] = fetch_email.show
                                 email_box.text = @email_hash[:email_text]
                             },
                             "\t \t ",
                            app.link('Delete', size: 12) {
                                delete_an_email
                             }
                )
            end
        end
        # :description delete the email from the server
        def delete_an_email
            if Shoes::Dialog.new.confirm('Are you sure, cannot be undo')
                Shoes::Dialog.new.alert  @email_hash[:email_object]
            end
        end
        def mark_an_email_as_reviewed
            Shoes::Dialog.new.alert @email_hash[:email_object]
        end

    end
end