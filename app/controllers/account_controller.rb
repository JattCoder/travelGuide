class AccountController < ApplicationController
    skip_before_action :verify_authenticity_token, raise: false
    def login
        if params[:email] && params[:password]
            if params[:email] == '' || params[:password] == ''
                render json: {'Message'=>params[:email] == '' ? 'Email Field is Empty!' : 'Password Field is Empty!','Error'=>true,'Info'=>{}}
            else
                acc = Account.find_by(email: params[:email])
                if acc 
                    if acc.digest_password == params[:password]
                        render json: {'Message'=>'In-correct Password','Error'=>false,'Info'=>{}}
                    else
                        render json: {'Message'=>'Success','Error'=>true,'Info'=>acc.as_json(except: [:password_digest])}
                    end
                else
                    render json: {'Message'=>'Account Not Found from Rails API','Error'=>true,'Info'=>{}}
                end
            end
        else
            render json: {'Message'=>'Network Error!','Error'=>true,'Info'=>{}}
        end
    end

    def create
        if params[:name] && params[:email] && params[:password]
            if params[:name] == '' || params[:email] == '' || params[:password] == ''
                render json: {'Message'=> params[:name] == '' ? 'Name is Empty!'
                : params[:email] == '' ? 'Email is Empty'
                : 'Please! Check Your Password!','Error'=>true,'Info'=>{}}
            else
                if Account.find_by(email: params[:email])
                    render json: {'Message'=>'Account already exists!', 'Error'=>true, 'Info'=>{}}
                else
                    acc = Account.new(name:params[:name],email:params[:email],phone:params[:phone] ? params[:phone]:'',password_digest:params[:password])
                    if acc.save
                        render json: {'Message'=>'Success','Error'=>false,'Info'=> acc.as_json(except: [:password_digest])}
                    else
                        render json: {'Message'=>'Failed to Create Account', 'Error'=>true, 'Info'=>{}}
                    end
                end
            end
        else
            render json: {'Message'=>'Network Error!','Error'=>true,'Info'=>{}}
        end
    end

    def delete
        if params[:id] && params[:email]
            if params[:id] == '' || params[:email] == ''
                render json: {'Message'=>'Network Error!','Error'=>true,'Info'=>{}}
            else
                acc = Account.find_by(id: params[:id])
                if acc
                    if acc.email == params[:email]
                        name = acc.name
                        deleted = acc.destroy
                        render json: {'Message'=> deleted ? 'Successfully Deleted Account'
                        : 'Failed to Delete Account!','Error'=>deleted ? false : true,'Info'=>{}}
                    else
                        render json: {'Message'=>'Invalid User!','Error'=>true,'Info'=>{}}
                    end
                else
                    render json: {'Message'=>'Invalid User!','Error'=>true,'Info'=>{}}
                end
            end
        else
            render json: {'Message'=>'Network Error!','Error'=>true,'Info'=>{}}
        end
    end

end