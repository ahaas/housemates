#Kevin Sung

class TasksController < ApplicationController
  def show
    @tasks = current_user.household.tasks.to_a
                       .sort_by! {:created_at}
    render 'show'
  end

  def create
    if Task.new(name: params[:name], completed: false).name != ""
      @task = Task.new(name: params[:name], completed: false)
      @task.household = current_user.household
      if @task.save
        flash[:success] = 'New task created'
        redirect_to tasks_show_path
      else
        flash[:notice] = 'Error: task was NOT created'
        render tasks_show_path
      end
    else
      @tasks = current_user.household.tasks.to_a
                       .sort_by! {:created_at}
      flash[:danger] = 'Error: task needs name'
      render tasks_show_path
    end
  end

  def delete
    if Task.find(params[:id]).destroy
      flash[:success] = 'Task successfully deleted'
      redirect_to :back
    else
      flash[:notice] = 'Error: task was NOT deleted'
      render tasks_show_path
    end
  end
  
  def complete
    task = Task.find(params[:checkbox_id])
    if params[:checked] == 'true'
      task.completed = true
    else
      task.completed = false
    end
    task.save
    redirect_to tasks_show_path
  end
  
  def assign
    task = Task.find(params[:task_id])
    if task.user
      task.user = nil
    else
      task.user = current_user
    end
    task.save
    redirect_to tasks_show_path
  end
  
end
