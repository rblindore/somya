# require File.join(Rail.root, 'lib/has_and_belongs_to_many_with_deferred_save')

ActionController::Base.send :include, InPlaceEditing
ActionController::Base.send :include, CustomInPlaceEditing
ActionController::Base.helper InPlaceMacrosHelper
