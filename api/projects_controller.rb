module Api
  class ProjectsController < ApplicationController
    skip_filter :set_current_user_and_project, :apply_currents, :clean_data
    http_basic_authenticate_with name: "admin", password: "secret"
    
    # Method: GET
    # Ex: curl /api/projects
    # Returns JSON array of all projects
    def index  
      render :json => Project.all
    end
    
    # Method: POST
    # Creates new project.
    # Params: name (String), description (String), deleted (Bool - 0 or 1), version (Int), library (Bool - 0 or 1), bug_tracker_id (Int - FK)
    # Ex:
    #  curl -X POST -H "Content-Type: application/json" -d '{"name":"testing103", "description":"test desc", "deleted":"0", "version":"0", "library":"0", "bug_tracker_id":"1"}' localhost:3000/api/projects -u "admin:secret" 
    def create
      @proj = Project.new
      @proj.name = params[:name]
      @proj.description = params[:description]
      @proj.deleted = params[:deleted]
      @proj.version = params[:version]
      @proj.library = params[:library]
      @proj.bug_tracker_id = params[:bug_tracker_id]
      
      if @proj.save
        render :json => {:status => :created}
      else
        render :json => @proj.errors.full_messages, :status => :bad_request
      end
    end
    
    # Method GET
    # Ex: curl localhost:3000/api/projects/1 -u "admin:secret"
    # Returns JSON object for the specified project
    def show  
      render :json => Project.find_by_id(params[:id])
    end
    
    # Method: PUT
    # Updates record for specified project
    # Ex:
    #  curl -X PUT -H "Content-Type: application/json" -d '{"name":"testing104", "description":"test update description 4", "deleted":"1", "version":"0", "library":"0", "bug_tracker_id":"1"}' localhost:3000/api/projects/1 -u "admin:secret"
    def  update
      @proj = Project.find_by_id(params[:id])
      
      if @proj.update_attributes(name: params[:name], description: params[:description], deleted: params[:deleted], version: params[:version], library: params[:library], bug_tracker_id: params[:bug_tracker_id])
        render :json => {:status => :ok}
      else
        render :json => {:error => @proj.errors.full_messages, :status => :bad_request}
      end
    end
    
    # Method: DELETE
    # Ex: curl -X DELETE localhost:3000/api/projects/1 -u "admin:secret"
    # Returns JSON array of all projects
    def destroy
      @prof = Project.find_by_id(params[:id])
      
      if @prof.destroy
        render :json => {:status => :ok}
      else
        render :json => {:error => @proj.errors.full_messages, :status => :bad_request}
      end
    end

    # Method: GET
    # Ex: curl localhost:3000/api/projects/2/priorities -u "admin:secret"
    # Returns JSON array of all projects
    def priorities
      render :json => {:data => Project::Priorities}
    end
    
    # Method: GET
    # Ex: curl localhost:3000/api/projects/deleted -u "admin:secret"
    # Returns JSON array of all deleted projects
    def deleted
      render :json => Project.where("deleted = 1")
    end
    
    # Method: GET
    # Ex: curl localhost:3000/api/projects/11/products -u "admin:secret"
    # Returns JSON array of all products associated with this project
    def products
      project = Project.find(params[:id])
      bt = project.bug_tracker
      render :json => {error: "Project has no bug tracker!", status: :bad_request} unless bt
      products = project.bug_products
      
      render :json => {:data => products.map(&:to_data)}
    end
  end
end