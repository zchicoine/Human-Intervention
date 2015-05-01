class Email

    def body
        'email body'
    end
    def subject
        'email subject'
    end
    def from
        'emai@eami.com'
    end
    def date
        '000'
    end
    def show
        "Subject: #{subject} \n From: #{from} \n Date: #{date} \n--------------------------- \n Body: #{body}
         --------------------------###############################--------------------------"
    end
end


email_instance = Email.new
i = 0
Shoes.app width: 1300, height: 700 do
    stack  height:650  , width: 300 do
        button('fetch')  do
            50.times do
               para  link(i.to_s) {para 'ha'}
                i = 1+ i
            end
        end
    end

    stack margin_left: 300, margin_top: 5, height:650, width:600 do
        para email_instance.show
    end
    #edit_line width: 120
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