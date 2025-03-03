module MethodInjector
  def self.hook_method(target, target_method, &user_block)
    target_method = target.instance_method(target_method)
    target.define_method target_method.name do |*args, **kwargs, &blk|
      user_block.call(target_method.bind(self), args, **kwargs, &blk)
    end
  end

  def self.inject_debugger(target, target_method)
    require "pry"

    hook_method(target, target_method) do |mth, *args, **kwargs, &blk|
      binding.pry # rubocop:disable Lint/Debugger(Rubocop)
      mth.call(*args, **kwargs, &blk)
    end
  end
end
