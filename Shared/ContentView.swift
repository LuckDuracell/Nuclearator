//
//  ContentView.swift
//  Shared
//
//  Created by Luke Drushell on 3/30/22.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @State var fancyTheme = true
    @State var showBoom = false
    
    @State var power: Float = 5000000
    @State var output: Float = 0
    
    @State var height: Int = 0
    @State var protons: Int = 0
    @State var neutrons: Int = 0
    @State var MapLocations = [
        MapLocation(name: "", latitude: 38.552860, longitude: -121.732910), MapLocation(name: "Nuclear Bomb", latitude: 38.552860, longitude: -121.732910)]
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 38.552860, longitude: -121.732910), span: MKCoordinateSpan(latitudeDelta: 3.5, longitudeDelta: 3.5))
    //height of map is 1,240
    @FocusState var showKeyboard
    
    @State var location = "West"
    @State private var locations = ["West", "West Alt", "Central", "East"]
    @State var showDisclaimer = false
    @State var showMap = true
    
    @State var bombScale: CGFloat = 0
    
    @State var presets = ["Custom", "Tsar Bomba x100", "Tsar Bomba", "Little Boy", "Fat Man", "Castle Bravo", "B41"]
    @State var preset = "Tsar Bomba x100"
    
    var body: some View {
        ZStack {
            ScrollView {
                HStack {
                    Picker("Location", selection: $location, content: {
                        ForEach(locations, id: \.self, content: { location in
                            Text(location)
                        })
                    })
                    .padding(5)
                    .background(.regularMaterial)
                    .cornerRadius(10)
                    Spacer()
                    Button {
                        withAnimation {
                            showDisclaimer.toggle()
                        }
                    } label: {
                       Image(systemName: "info.circle")
                            .padding(5)
                            .background(.regularMaterial)
                            .cornerRadius(10)
                    }
                }
                    .padding(.horizontal)
                if showDisclaimer {
                    Text("Disclaimer: I don't condone dropping nuclear weapons... ever. That would be really messed up, this is just a project for Physics class")
                        .padding(.horizontal)
                        .foregroundColor(fancyTheme ? .white : .primary)
                }
                VStack {
                    HStack {
                    Picker("Presets", selection: $preset, content: {
                        ForEach(presets, id: \.self, content: { preset in
                            Text(preset)
                        })
                    })
                    .padding(5)
                    .background(.regularMaterial)
                    .cornerRadius(10)
                    .padding(.horizontal)
                        Spacer()
                    }
                    HStack {
                            Text("POWER OF EXPLOSION (KILOTONS OF TNT)")
                                .font(.caption)
                                .foregroundColor(fancyTheme ? .white : .primary)
                        Spacer()
                        .onChange(of: preset, perform: { selection in
                            switch selection {
                            case "Tsar Bomba x100":
                                power = 5000000
                            case "Tsar Bomba":
                                power = 50000
                            case "Little Boy":
                                power = 18
                            case "Fat Man":
                                power = 23
                            case "Castle Bravo":
                                power = 15000
                            case "B41":
                                power = 25000
                            default:
                                print("custom")
                            }
                        })
                    } .padding(.horizontal)
                            TextField("5,000,000", value: $power, format: .number)
                                .keyboardType(.decimalPad)
                                .focused($showKeyboard)
                                .padding(15)
                                .background(.regularMaterial)
                                .cornerRadius(15)
                                .padding(.horizontal)
                    .onChange(of: power, perform: { pow in
                        switch pow {
                        case 5000000:
                            preset = "Tsar Bomba x100"
                        case 50000:
                            preset = "Tsar Bomba"
                        case 18:
                            preset = "Little Boy"
                        case 23:
                            preset = "Fat Man"
                        case 15000:
                            preset = "Castle Bravo"
                        case 25000:
                            preset = "B41"
                        default:
                            preset = "Custom"
                        }
                    })
                    .onChange(of: location, perform: { lot in
                        switch location {
                        case "West":
                            for i in 0...(MapLocations.count - 1) {
                                MapLocations[i].latitude = 38.552860
                                MapLocations[i].longitude = (-121.732910)
                            }
                            region.center.latitude = 38.552860
                            region.center.longitude = (-121.732910)
                        case "West Alt":
                            for i in 0...(MapLocations.count - 1) {
                                MapLocations[i].latitude = 38.558480
                                MapLocations[i].longitude = (-121.748330)
                            }
                            region.center.latitude = 38.558480
                            region.center.longitude = (-121.748330)
                        case "Central":
                            for i in 0...(MapLocations.count - 1) {
                                MapLocations[i].latitude = 39.0558235
                                MapLocations[i].longitude = (-95.6890185)
                            }
                            region.center.latitude = 39.0558235
                            region.center.longitude = (-95.6890185)
                        default:
                            for i in 0...(MapLocations.count - 1) {
                                MapLocations[i].latitude = 40.748817
                                MapLocations[i].longitude = (-73.985428)
                            }
                            region.center.latitude = 40.748817
                            region.center.longitude = -73.985428
                        }
                        showMap = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                            showMap = true
                        })
                    })
                    if showMap {
                        Map(coordinateRegion: $region, annotationItems: MapLocations, annotationContent: { location in
                            MapAnnotation(
                               coordinate: location.coordinate,
                               content: {
                                   Circle()
                                       .stroke(.white, lineWidth: location.name == "" ? 2 : 0)
                                       .background(location.name == "" ? .orange.opacity(0.7) : .red)
                                       .clipShape(Circle())
                                       .frame(width: location.name == "" ? scaleExplosion(input: CGFloat(output), mapSpan: region.span) * 0.5 : 6, height: location.name == "" ? scaleExplosion(input: CGFloat(output), mapSpan: region.span) * 0.5 : 6, alignment: .center)
                                       .scaleEffect(location.name == "" ? CGFloat(bombScale) : 1, anchor: .center)
                                       .animation(.easeOut, value: bombScale)
                                       .scaledToFill()
                                  //Text(location.name)
                               }
                            )
                        })
                            .frame(width: UIScreen.main.bounds.width * 0.95, height: 350, alignment: .center)
                            .cornerRadius(25)
                            .overlay(
                                Color.orange.opacity(outputSafety(input: CGFloat(output), mapSpan: region.span, circleLot: MapLocations[0], region: region) ? 0.7 : 0)
                                    .cornerRadius(25)
                                    .allowsHitTesting(false)
                            )
                    }
                        if output != 0 {
                            Text("Blast Radius: \(output) kilometers")
                                .padding(10)
                                .background(.regularMaterial)
                                .cornerRadius(10)
                                .padding()
                                .foregroundColor(.white)
                        }
                        Button {
                            let funkyDory: Float32 = 10 * log(200/(0.0000000000000001))
                            output = 30 * sqrt(((power / 1000)/funkyDory * 4 * Float.pi))
                            withAnimation {
                                bombScale = 0
                                bombScale = 1
                            }
                        } label: {
                            Text("Calculate")
                                .padding(10)
                                .background(.regularMaterial)
                                .cornerRadius(10)
                                .padding()
                        }
                    
                    Spacer()
                    
                    Button {
                        fancyTheme.toggle()
                        showBoom = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5, execute: {
                            showBoom = false
                        })
                    } label: {
                        Text(fancyTheme ? "Ugly Mode" : "Normal Mode")
                            .padding(10)
                            .background(.regularMaterial)
                            .cornerRadius(10)
                            .padding()
                    }
        //                if UIDevice.current.userInterfaceIdiom == .phone {
        //                    Button {
        //                        guard let urlShare = URL(string: "https://apps.apple.com/us/app/watchable/id1586489845") else { return }
        //                               let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
        //                        activityVC.title = "Share the app with your friends!"
        //
        //                        UIApplication.shared.windows.first?.rootViewController?
        //                            .present(activityVC, animated: true, completion: nil)
        //
        //                    } label: {
        //                        Text("Share App")
        //                            .padding()
        //                    }
        //                }
                    
                }.toolbar(content: {
                ToolbarItemGroup(placement: .keyboard, content: {
                    HStack {
                        Spacer()
                        Button {
                            showKeyboard.toggle()
                        } label: {
                            Text("Done")
                        }
                    }
                })
            })
            }
        } .background (
            Image(fancyTheme ? "bg" : "")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 1.3, alignment: .center)
                .scaledToFill()
        )
        if showBoom {
            ShowBoom()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct MapLocation: Identifiable {
    let id = UUID()
    let name: String
    var latitude: Double
    var longitude: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

func scaleExplosion(input: CGFloat, mapSpan: MKCoordinateSpan) -> CGFloat {
    var output = CGFloat((3.5 / mapSpan.latitudeDelta ) * 350 * (input / 964) * 2)
    if output > UIScreen.main.bounds.width * 5 {
        output = 0
    }
    return output
}

func outputSafety(input: CGFloat, mapSpan: MKCoordinateSpan, circleLot: MapLocation, region: MKCoordinateRegion) -> Bool {
    let output = CGFloat((3.5 / mapSpan.latitudeDelta ) * 350 * (input / 964) * 2)
    var theBool = false
    if output > UIScreen.main.bounds.width * 5 {
        theBool = true
    }
    
    let circle = CLLocation(latitude: circleLot.latitude, longitude: circleLot.longitude)
    let position = CLLocation(latitude: region.center.latitude, longitude: region.center.longitude)
    if (circle.distance(from: position) / 250) > (output * 0.5) {
        theBool = false
    }
    
    return theBool
}
