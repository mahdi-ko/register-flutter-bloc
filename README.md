# register

Register page using bloc for state management.

## notes

1- a field named phone_digits is added to the countries json file for extra validation on the phone number field

2- the layout varies depending on the orientation of the device

3- Submitting the form validates the form and then calls the register method in the auth repository which mimics sending an asynchronous request by waiting for several seconds

4- Default user location is fetched usinng ipify service which retrieves location based on user's public ip address.

5- logout button doesn't empty register state on purpose for easier transition between the 2 pages.

## considerations

this is the first time I use bloc patten so I had to learn how to use it.
