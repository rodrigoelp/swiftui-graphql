const { PubSub, withFilter } = require('apollo-server');

const pubsub = new PubSub();

const { paginateResults } = require('./utils');

const TRIP_BOOKED = 'TRIP_BOOKED';
const NEW_MESSAGE = 'NEW_MESSAGE';

module.exports = {
	Subscription: {
		tripBooked: {
			subscribe: withFilter(
				() => pubsub.asyncIterator([TRIP_BOOKED]),
				async (payload, variables, context, info) => {
					let dataSource = context.currentUser.dataSources();
					let findUserByContext = await dataSource.userAPI.getUserId({ email: context.currentUser.user });
					let userIds = await dataSource.userAPI.getUserIdsForLaunch({ launchId: payload.tripBooked.id });
					return userIds.indexOf(findUserByContext) >= 0;
				}
			)
		},
		postedMessages: {
			subscribe: () => pubsub.asyncIterator([NEW_MESSAGE]),
		},
	},
	Query: {
		launches: async (_, { pageSize = 20, after }, { dataSources }) => {
			const allLaunches = await dataSources.launchAPI.getAllLaunches();
			// we want these in reverse chronological order
			allLaunches.reverse();

			const launches = paginateResults({
				after,
				pageSize,
				results: allLaunches
			});

			return {
				launches,
				cursor: launches.length ? launches[launches.length - 1].cursor : null,
				// if the cursor of the end of the paginated results is the same as the
				// last item in _all_ results, then there are no more results after this
				hasMore: launches.length ? launches[launches.length - 1].cursor !== allLaunches[allLaunches.length - 1].cursor : false
			};
		},
		launch: (_, { id }, { dataSources }) => dataSources.launchAPI.getLaunchById({ launchId: id }),
		passengerMessages: async (_, { pageSize = 20, after }, { dataSources }) => {
			const allMessages = await dataSources.userAPI.getAllMessages();

			const messages = paginateResults({
				after,
				pageSize,
				results: allMessages
			});

			return {
				messages,
				cursor: messages.length ? messages[messages.length - 1].cursor : "",
				// if the cursor of the end of the paginated results is the same as the
				// last item in _all_ results, then there are no more results after this
				hasMore: messages.length ? messages[messages.length - 1].cursor !== allMessages[allMessages.length - 1].cursor : false
			};
		},
		me: async (_, __, { dataSources }) => dataSources.userAPI.findOrCreateUser()
	},
	Mutation: {
		bookTrips: async (_, { launchIds }, { dataSources }) => {
			const results = await dataSources.userAPI.bookTrips({ launchIds });
			const launches = await dataSources.launchAPI.getLaunchesByIds({
				launchIds
			});
			let launchRefs = launches.map(item => {
				return {
					id: item.id
				};
			});
			launchRefs.forEach(launchRef => pubsub.publish(TRIP_BOOKED, { tripBooked: launchRef }));
			return {
				success: results && results.length === launchIds.length,
				message: results.length === launchIds.length ? 'trips booked successfully' : `the following launches couldn't be booked: ${launchIds.filter(id => !results.includes(id))}`,
				launches
			};
		},
		cancelTrip: async (_, { launchId }, { dataSources }) => {
			const result = dataSources.userAPI.cancelTrip({ launchId });

			if (!result)
				return {
					success: false,
					message: 'failed to cancel trip'
				};

			const launch = await dataSources.launchAPI.getLaunchById({ launchId });
			return {
				success: true,
				message: 'trip cancelled',
				launches: [launch]
			};
		},
		login: async (_, { email }, { dataSources }) => {
			const user = await dataSources.userAPI.findOrCreateUser({ email });
			if (user) return new Buffer(email).toString('base64');
		},
		addMessage: async (_, { message }, { dataSources }) => {
			let msg = await dataSources.userAPI.findOrCreateMessage({ message });
			if (msg) {
				pubsub.publish(NEW_MESSAGE, { postedMessages: msg });
			}
			return msg;
		},
	},
	Launch: {
		isBooked: async (launch, _, { dataSources }) => dataSources.userAPI.isBookedOnLaunch({ launchId: launch.id }),
		pax: async (launch, _, { dataSources }) => dataSources.userAPI.paxOnLaunch({ launchId: launch.id })
	},
	Mission: {
		// make sure the default size is 'large' in case user doesn't specify
		missionPatch: (mission, { size } = { size: 'LARGE' }) => {
			return size === 'SMALL' ? mission.missionPatchSmall : mission.missionPatchLarge;
		}
	},
	User: {
		trips: async (_, __, { dataSources }) => {
			// get ids of launches by user
			const launchIds = await dataSources.userAPI.getLaunchIdsByUser();

			if (!launchIds.length) return [];

			// look up those launches by their ids
			return (
				dataSources.launchAPI.getLaunchesByIds({
					launchIds
				}) || []
			);
		}
	}
};
