//
//  ContentView.swift
//  PinchApp
//
//  Created by Sampel on 04/03/2023.
//

import SwiftUI

struct ContentView: View {
    // MARK: - PROPERTY
    @State private var isAnimating : Bool = false
    @State private var ImageScale : CGFloat = 1
    @State private var imageOffset: CGSize = .zero
    @State private var  isDrawerOpen : Bool = false
    
    let pages : [Page] = pageData
    @State private var pageIndex : Int = 1
    
    // MARK: - FUNCTION
    func resetImageState() {
        return withAnimation(.spring()){
            ImageScale = 1
            imageOffset = .zero
        }
    }
    
    func currentPage() -> String {
        return pages [pageIndex - 1].imageName
    }
    // MARK : - CONTENT
    var body: some View {
        NavigationView{
            ZStack{
                Color.clear
                //MARK: PAGE IMAGE
                Image(currentPage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(x: imageOffset.width, y: imageOffset.height)
                    .scaleEffect(ImageScale)
                
                // MARK1 - TAP GESTURE
                    .onTapGesture(count: 2, perform: {
                        if ImageScale == 1 {
                            withAnimation(.spring()){
                                ImageScale = 5
                            }
                        }else {
                            resetImageState()
                        }
                    })
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                withAnimation(.linear(duration: 1)){
                                    imageOffset = value.translation
                                }
                                
                            }
                            .onEnded{ _  in
                                      if ImageScale <= 1 {
                                          resetImageState()
                                      }
                            }
                    )
                // MARK : -3 MAGNIFICATION
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                withAnimation(.linear(duration: 1)) {
                                    if ImageScale >= 1 && ImageScale <= 5 {
                                        ImageScale = value
                                    } else  if ImageScale > 5 {
                                        ImageScale = 5
                                    }
                                }
                            }
                            .onEnded { _ in
                                if ImageScale > 5 {
                                    ImageScale = 5
                                } else if  ImageScale <= 1 {
                                    resetImageState()
                                }
                        }
                    )
                
            } // : ZSTACK
            .navigationTitle("Pinch & zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: {
                isAnimating = true
            })
            // MARK: INFOPANEL
            .overlay(
                InfoPanelView(scale: ImageScale, offset: imageOffset)
                    .padding(.horizontal)
                    .padding(.top, 30)
                    
                , alignment: .top
            )
            .overlay(
                Group {
                    HStack{
                        // SCALE DOWN
                        Button {
                            withAnimation(.spring()) {
                                if ImageScale > 1 {
                                ImageScale -= 1
                                    
                                    if ImageScale <= 1 {
                                        resetImageState()
                                    }
                                }
                                
                            }
                            
                        } label : {
                            ControlImageView(icon: "minus.magnifyingglass")
                        }
                        
                        //RESET
                        Button {
                            resetImageState()
                        } label : {
                            ControlImageView(icon: "arrow.up.left.and.down.right.magnifyingglass")
                        }
                        //SCALE UP
                        Button {
                            withAnimation(.spring()) {
                                if ImageScale < 5 {
                                    ImageScale += 1
                                    
                                    if ImageScale > 5 {
                                        ImageScale = 5
                                    }
                                }
                            }
                        } label : {
                            ControlImageView(icon: "plus.magnifyingglass")
                        }
                    }
                    .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                }
                    .padding(.bottom, 30), alignment: .bottom
                    
                    
            
            )
            // MARK : - DRAWER
            .overlay(
                HStack(spacing : 12) {
                    // MARK DRAWER HANDLE
                        Image(systemName: isDrawerOpen ? "chevron.compact.right" : "chevron.compact.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .padding(8)
                        .foregroundStyle(.secondary)
                        .onTapGesture(perform: {
                            withAnimation(.easeOut){
                                isDrawerOpen.toggle()
                            }
                        })
                    // MARK : THUMBNAILS
                    ForEach(pages) { items in
                        Image(items.thumbName)
                            .resizable()
                            .scaledToFit()
                            .frame (width : 80)
                            .cornerRadius(8)
                            .shadow(radius : 4)
                            .opacity(isAnimating ? 1 : 0)
                            .animation(.easeOut(duration : 0.5), value : isDrawerOpen)
                            .onTapGesture( perform: {
                                isAnimating = true
                                pageIndex = items.id
                            })
                        
                    }
                    Spacer()
                }
                    .padding(EdgeInsets (top: 16, leading: 8, bottom: 16, trailing: 8))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                    .frame (width : 260)
                    .padding(.top, UIScreen.main.bounds.height / 12 )
                    .offset(x: isDrawerOpen ? 20 : 215)
                , alignment : .topTrailing
             )
        } // : NAVIGATION
        .navigationViewStyle(.stack)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
            
    }
}
