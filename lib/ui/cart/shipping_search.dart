import 'package:e_shop/models/settings/shipping_model.dart';
import 'package:e_shop/provider/settings_provider.dart';
import 'package:e_shop/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShippingSearch extends StatefulWidget {
  const ShippingSearch({Key? key}) : super(key: key);

  @override
  State<ShippingSearch> createState() => _ShippingSearchState();
}

class _ShippingSearchState extends State<ShippingSearch> {
  //dummy data
  ShippingModel? shippingListFiltered = ShippingModel();
  TextEditingController searchTextController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    shippingListFiltered = settingsProvider.shippingList;

    print("LIST SHIPPING ${shippingListFiltered}");

    Widget customerDynamicCardVertical(ShipData? myCustomer) {
      return GestureDetector(
        onTap: () {
          settingsProvider.selectedShip = myCustomer.id;
          print("shipID nya adalah: ${settingsProvider.selectedShip}");
          Navigator.pop(context);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          margin: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 4,
                    offset: const Offset(0, 0))
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        myCustomer!.namaKurir.toString(),
                        style: poppins.copyWith(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: semiBold,
                            fontSize: 18,
                            color: backgroundColor1),
                        maxLines: 2,
                      ),
                      Text(
                        "Rp. 15000",
                        style: poppins.copyWith(
                            fontWeight: regular,
                            color: backgroundColor3,
                            overflow: TextOverflow.ellipsis),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        top: true,
        left: true,
        right: true,
        bottom: true,
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                color: backgroundColor3,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const SizedBox(
                        width: 20, //MediaQuery.of(context).size.width * 0.1,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      "Pilih Metode Pengiriman",
                      style: poppins.copyWith(
                          fontSize: 20,
                          fontWeight: semiBold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (shippingListFiltered!.shipData!.isEmpty) ...[
                Expanded(
                    child: Center(
                        child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.map,
                      size: 48,
                    ),
                    Text(
                      "Alamat tidak tersedia",
                      style:
                          poppins.copyWith(fontWeight: regular, fontSize: 20),
                    ),
                  ],
                )))
              ] else ...[
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    itemCount: shippingListFiltered?.shipData?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return customerDynamicCardVertical(
                          shippingListFiltered?.shipData![index]);
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
