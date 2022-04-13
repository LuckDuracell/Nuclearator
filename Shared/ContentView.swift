//
//  ContentView.swift
//  Shared
//
//  Created by Luke Drushell on 3/30/22.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @State var power: Float = 50
    @State var output: Float = 0
    
    @State var height: Int = 0
    @State var protons: Int = 0
    @State var neutrons: Int = 0
    @State var MapLocations = [
        MapLocation(name: "", latitude: 38.552860, longitude: -121.732910), MapLocation(name: "Nuclear Bomb", latitude: 38.552860, longitude: -121.732910)]
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.382860, longitude: -121.732810), span: MKCoordinateSpan(latitudeDelta: 4.5, longitudeDelta: 4.5))
    //height of map is 1,240
    @FocusState var showKeyboard
     
    var body: some View {
        ScrollView {
        VStack {
            HStack {
                    Text("POWER OF EXPLOSION (MEGATONS OF TNT)")
                        .font(.caption)
                        .foregroundColor(.gray)
                Spacer()
            } .padding(.horizontal)
                    TextField("50", value: $power, format: .number)
                        .keyboardType(.numberPad)
                        .focused($showKeyboard)
                        .padding(15)
                        .background(.thinMaterial)
                        .cornerRadius(15)
                        .padding(.horizontal)
                Map(coordinateRegion: $region, annotationItems: MapLocations, annotationContent: { location in
                    MapAnnotation(
                       coordinate: location.coordinate,
                       content: {
                           Image(systemName: location.name == "" ? "circle.fill" :  "circle.fill")
                               .resizable()
                               .foregroundColor(location.name == "" ? .orange.opacity(0.8) : .red)
                               .frame(width: location.name == "" ? scaleExplosion(input: CGFloat(output), mapSpan: region.span) * 0.5 : 6, height: location.name == "" ? scaleExplosion(input: CGFloat(output), mapSpan: region.span) * 0.5 : 6, alignment: .center)
                               .scaledToFill()
                               .rotationEffect(Angle(degrees: 180))
                          //Text(location.name)
                       }
                    )
                })
                    .frame(width: UIScreen.main.bounds.width * 0.95, height: 350, alignment: .center)
                    .cornerRadius(25)
                    .overlay(
                        Color.orange.opacity(outputSafety(input: CGFloat(output), mapSpan: region.span, circleLot: MapLocations[0], region: region) ? 0.8 : 0)
                            .cornerRadius(25)
                            .allowsHitTesting(false)
                    )
                if output != 0 {
                    Text("Blast Radius: \(output) kilometers")
                        .padding()
                }
                Button {
                    let funkyDory: Float32 = 10 * log(200/(0.0000000000000001))
                    output = 30 * sqrt((power/funkyDory * 4 * Float.pi))
                } label: {
                    Text("Calculate")
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
        .padding(.top, 50)
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
    let latitude: Double
    let longitude: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

func scaleExplosion(input: CGFloat, mapSpan: MKCoordinateSpan) -> CGFloat {
    var output = CGFloat((4.5 / mapSpan.latitudeDelta ) * 350 * (input / 1240) * 2)
    if output > UIScreen.main.bounds.width * 5 {
        output = 0
    }
    return output
}

func outputSafety(input: CGFloat, mapSpan: MKCoordinateSpan, circleLot: MapLocation, region: MKCoordinateRegion) -> Bool {
    let output = CGFloat((4.5 / mapSpan.latitudeDelta ) * 350 * (input / 1240) * 2)
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
