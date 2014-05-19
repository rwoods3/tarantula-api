module Api
  class UsersController < ApplicationController
    skip_filter :set_current_user_and_project, :apply_currents, :clean_data
    http_basic_authenticate_with name: "admin", password: "secret"
    
    # Method: GET
    # Ex: curl localhost:3000/api/projects/2/users -u "admin:secret"
    # Returns JSON array of all users for this project
    def index  
      render :json => Project.find_by_id(params[:project_id]).users.all
    end
    
    # Method: POST
    # Ex: curl -X POST -H "Content-Type: application/json" -d '{"login":"test_user_11", "email":"test11@test.com", "phone":"1111112222", "realname":"test user name", "description":"test user 11 description"}' localhost:3000/api/projects/11/users -u "admin:secret"
    # Create a new user in project specified by :project_id
    def create
      if User.connection.insert("INSERT INTO users (login, email, phone, realname, description, latest_project_id, created_at, updated_at, deleted, version, type) VALUES ('#{params[:login]}', '#{params[:email]}', '#{params[:phone]}', '#{params[:realname]}', '#{params[:description]}', #{params[:project_id]}, #{params[:created_at] ? 'params[:created_at]' : "NULL"}, #{params[:updated_at] ? 'params[:updated_at]' : "NULL"}, #{params[:deleted] ? params[:deleted] : 0}, #{params[:version] ? params[:version] : 0}, #{params[:type] ? 'params[:type]' : "NULL"})")
        render :json => {:status => :created}
      else
        render :json => {:error => @user.errors.full_messages, :status => :bad_request}
      end
    end
    
    # Method: GET
    # Ex: curl localhost:3000/api/projects/2/users/2 -u "admin:secret"
    # Returns JSON object for user having :id and belonging to project :project_id
    def show
      render :json => Project.find(2).users.find(2)
    end
    
    # Method: DELETE
    # Ex: curl -X DELETE -H "Content-Type: application/json" localhost:3000/api/projects/2/users/2 -u "admin:secret"
    # Deletes user from project
    def destroy
      @user = Project.find(params[:project_id]).users.find(params[:id])
      
      if @user.destroy
        render :json => {:status => :ok}
      else
        render :json => {:error => @user.errors.full_messages, :status => :bad_request}
      end
    end
    
    # Method: PUT
    # Ex: curl -X PUT -H "Content-Type: application/json" -d '{"login":"test_user_update_11", "emai1@test.com","phone":"1231231234", "realname":"test user update name", "description":"Updating test user 11 description", "password":"testing11"}' localhost:3000/api/projects/11/users/27 -u "admin:secret"
    # Update user attributes
    def update
      @user = User.find(params[:id])
      
      @user.update_attribute('login', params[:login]) if params[:login]
      @user.update_attribute('email',params[:email]) if params[:email]
      @user.update_attribute('phone', params[:phone]) if params[:phone]
      @user.update_attribute('realname', params[:login]) if params[:realname]
      @user.update_attribute('description', params[:description]) if params[:description]
      @user.update_attribute('latest_project_id', params[:latest_project_id]) if params[:latest_project_id]
      @user.update_attribute('created_at', params[:created_at]) if params[:created_at]
      @user.update_attribute('updated_at', params[:updated_at]) if params[:updated_at]
      @user.update_attribute('deleted', params[:deleted]) if params[:deleted]
      @user.update_attribute('version', params[:version]) if params[:version]
      @user.update_attribute('type', params[:type]) if params[:type]
      
      render :json => {:status => :ok}
    end
  end
end