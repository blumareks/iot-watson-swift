use_frameworks!


def shared_pod
	pod 'BMSAnalyticsAPI', '~> 2.2'
end


target 'BMSCore iOS' do
	platform :ios, '9.0'
	shared_pod
end

target 'BMSCore Tests' do
	platform :ios, '9.0'
	shared_pod
end

target 'BMSCore watchOS' do
	platform :watchos, '2.0'
	shared_pod
end

target 'TestApp iOS' do
	platform :ios, '9.0'
	shared_pod
end

target 'TestApp watchOS' do
	shared_pod
end

target 'TestApp watchOS Extension' do
	platform :watchos, '2.0'
	shared_pod
end
