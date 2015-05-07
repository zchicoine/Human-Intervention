# fetch emails from the servers
module EmailOperations
    module Backend

        class << self
            # :return [Array] of [Email]. Only return 10 not reviewed emails at a time
            def fetch_emails_all
                emails_array = []
                actual_emails = DataController.new.retrieve_unsuccessful_emails.take(10)

                actual_emails.each do |email|
                    emails_array.push(Email.new({body:email['body'], subject:email['subject'], date:email['date'], from: 'hard coded for now', email_address:email['email_address']}))
                end
                emails_array
            end
        end # self

        # email class
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
    end
end


