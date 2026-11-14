# Maintains the iOS Xcode project. Run with CocoaPods' bundled xcodeproj:
#   GEM_HOME=$(dirname $(dirname $(readlink -f $(brew --prefix cocoapods)/libexec/bin/pod))) ruby tool/ios_project.rb <command>
# Commands:
#   widget         add the DayWidget extension target (idempotent)
#   demo <TEAM>    local demo on a free Apple ID: bundle id *.demo, own App Group, team
#   store          back to store values (do this before committing project.pbxproj)
require 'xcodeproj'

APP_ID = 'com.digiwitch.app'
project = Xcodeproj::Project.open(File.join(__dir__, '..', 'ios', 'Runner.xcodeproj'))
runner = project.targets.find { |t| t.name == 'Runner' }
widget = project.targets.find { |t| t.name == 'DayWidget' }

# Bundle ids, App Group and team for the app and its widget, in one place.
def identify(targets, id, team)
  targets.compact.each do |t|
    t.build_configurations.each do |c|
      s = c.build_settings
      s['PRODUCT_BUNDLE_IDENTIFIER'] = t.name == 'Runner' ? id : "#{id}.DayWidget"
      s['APP_GROUP_ID'] = "group.#{id}"
      team ? s['DEVELOPMENT_TEAM'] = team : s.delete('DEVELOPMENT_TEAM')
    end
  end
end

case ARGV[0]
when 'widget'
  abort 'DayWidget already exists' if widget
  widget = project.new_target(:app_extension, 'DayWidget', :ios, '17.0')
  group = project.main_group.new_group('DayWidget', 'DayWidget')
  widget.add_file_references([group.new_file('DayWidget.swift')])
  group.new_file('Info.plist')
  group.new_file('DayWidget.entitlements')
  project.main_group.find_subpath('Runner').new_file('Runner.entitlements')

  widget.build_configurations.each do |c|
    # Same Flutter xcconfig as the app, so the version numbers match (FLUTTER_BUILD_NAME/NUMBER).
    c.base_configuration_reference =
      runner.build_configurations.find { |r| r.name == c.name }.base_configuration_reference
    c.build_settings.merge!(
      'INFOPLIST_FILE' => 'DayWidget/Info.plist',
      'CODE_SIGN_ENTITLEMENTS' => 'DayWidget/DayWidget.entitlements',
      'CODE_SIGN_STYLE' => 'Automatic',
      'GENERATE_INFOPLIST_FILE' => 'NO',
      'SWIFT_VERSION' => '5.0',
      'TARGETED_DEVICE_FAMILY' => '1,2',
      'IPHONEOS_DEPLOYMENT_TARGET' => '17.0', # containerBackground; the app itself stays on 15
      'SKIP_INSTALL' => 'YES',
      'PRODUCT_NAME' => '$(TARGET_NAME)',
      'LD_RUNPATH_SEARCH_PATHS' =>
        ['$(inherited)', '@executable_path/Frameworks', '@executable_path/../../Frameworks'],
    )
  end
  runner.build_configurations.each do |c|
    c.build_settings['CODE_SIGN_ENTITLEMENTS'] = 'Runner/Runner.entitlements'
  end

  runner.add_dependency(widget)
  embed = runner.new_copy_files_build_phase('Embed Foundation Extensions')
  embed.symbol_dst_subfolder_spec = :plug_ins
  embed.add_file_reference(widget.product_reference).settings = { 'ATTRIBUTES' => ['RemoveHeadersOnCopy'] }
  # Must run before Flutter's "Thin Binary" script, or Xcode reports a build cycle.
  thin = runner.build_phases.index { |p| p.display_name == 'Thin Binary' }
  runner.build_phases.move(embed, thin)

  team = runner.build_configurations.first.build_settings['DEVELOPMENT_TEAM']
  id = runner.build_configurations.first.build_settings['PRODUCT_BUNDLE_IDENTIFIER']
  identify([runner, widget], id, team)
when 'demo'
  abort 'usage: demo <TEAM_ID>' unless ARGV[1]
  identify([runner, widget], "#{APP_ID}.demo", ARGV[1])
when 'store'
  identify([runner, widget], APP_ID, nil)
else
  abort 'usage: ios_project.rb widget | demo <TEAM_ID> | store'
end
project.save
puts "ok: #{ARGV.join(' ')}"
