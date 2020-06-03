//
//  SaleView.swift
//  FlyShop
//
//  Created by Karen Mirakyan on 5/8/20.
//  Copyright © 2020 Karen Mirakyan. All rights reserved.
//

import SwiftUI
import WaterfallGrid

struct SaleView: View {
    
    @ObservedObject var saleVM = SaleViewModel()
    
    var body: some View {

        NavigationView {
            ZStack {
                AllShopsBackground()
                
                VStack {
                    TopChat(message: "Կարծես թե զեղչեր ունենք:\nԲաց մի՛ թող այս հնարավորությունը:")
                    
                    WaterfallGrid(self.saleVM.productsUnderSale) { product in
                        SingleSaleProduct(product: product)
                    }.scrollOptions(direction: .horizontal, showsIndicators: false).gridStyle(
                        animation: .easeInOut(duration: 1)
                    )
                    
                    BottomChat()
                }
                
                if self.saleVM.showLoading {
                    Loading()
                }
            }
            .navigationBarTitle(Text( "FlyShop"), displayMode: .inline)
        }
    }
}

struct SaleView_Previews: PreviewProvider {
    static var previews: some View {
        SaleView()
    }
}
