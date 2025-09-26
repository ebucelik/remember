//
//  RewardedViewModel.swift
//  remember
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 26.09.25.
//

import GoogleMobileAds
import Combine

class RewardedViewModel: NSObject, ObservableObject, FullScreenContentDelegate {

    private let testAdId = "ca-app-pub-3940256099942544/1712485313"
    private let liveAdId = "ca-app-pub-7505202099236765/6195340541"

    @Published var showSymbols = false
    private var rewardedAd: RewardedAd?

    func loadAd() async {
        do {
            DispatchQueue.main.async {
                self.showSymbols = false
            }

            rewardedAd = try await RewardedAd.load(
                with: liveAdId,
                request: Request()
            )
            rewardedAd?.fullScreenContentDelegate = self
        } catch {
            print("Failed to load rewarded ad with error: \(error.localizedDescription)")
        }
    }

    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("\(#function) called")
        // Clear the rewarded ad.
        rewardedAd = nil

        Task {
            await loadAd()
        }
    }

    func showAd() {
        guard let rewardedAd else {
            Task {
                await loadAd()
            }

            return print("Ad was not ready.")
        }

        rewardedAd.present(from: nil) {
            self.showSymbols = true
        }
    }
}
